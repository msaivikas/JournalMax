import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottom_buttons_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../database_helper.dart';
import '../authentication/auth_helper_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userEmail;

  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _journalEntries = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool defaultDateSelect = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _loadUserEmail();
    await _loadJournalEntries();
    return;
  }

  void setCalendarDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _loadUserEmail() async {
    String? email = await AuthHelperLocal.getUserEmail();
    if (email != null) {
      _userEmail = email;
      setState(() {});
      return;
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await AuthHelperLocal.setUserEmail(user.email!);
        _userEmail = user.email;
      } else {
        _userEmail = await AuthHelperLocal.getUserEmail();
      }
      setState(() {});
    }
    return;
  }

  void _sendReportEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'fleventoid@gmail.com',
      query:
          'subject=JournalMax App Issue Report&body=Describe your issue here...',
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      // Could not launch email client
      throw 'Could not launch $params';
    }
  }

  Future<void> _loadJournalEntries() async {
    if (_userEmail == null) return;
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    final entries =
        await _databaseHelper.getTodaysJournal(_userEmail!, formattedDate);
    setState(() {
      _journalEntries = entries;
    });
  }

  void _addJournalEntry() async {
    final String selectedDateString =
        DateFormat('yyyy-MM-dd').format(_selectedDate);
    final String currentTimeStamp =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    TextEditingController localTextEditingController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: localTextEditingController,
                        maxLines: 10,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.black,
                          hintText: 'Write your thoughts here...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final textContent = localTextEditingController.text;
                          if (_userEmail == null || textContent.isEmpty) return;
                          await _databaseHelper.insertJournal(
                              _userEmail!,
                              textContent,
                              selectedDateString,
                              currentTimeStamp);
                          _loadJournalEntries();
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'SAVE',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showCalendar() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.black,
            child: TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2200),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _loadJournalEntries();
                  setCalendarDate(_selectedDate);
                });

                Navigator.pop(context);
              },
              calendarFormat: CalendarFormat.month,
              onPageChanged: (focusedDay) {
                _selectedDate = focusedDay;
              },
              calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(color: Colors.white),
                todayTextStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.black),
                todayDecoration: BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.lightGreen,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                  color: Colors.white,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
                titleCentered: true,
                formatButtonVisible: false,
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.blue),
                weekendStyle: TextStyle(color: Colors.orange),
              ),
            ),
          );
        });
  }

  void _processAI() async {
    // use firebase cloud function to handle this.
    return;
  }

  void _popupDeleteWarning() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to permanently delete all your local data? \n There is no way to bring it back once deleted.\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'If you simply sign out without deleting your data, you can access it the next time you sign in. No other user can access it even after another user signs in.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _databaseHelper.deleteAllUserJournals(_userEmail!);
                        _databaseHelper.deleteAllActionItems(_userEmail!);
                        _loadJournalEntries();
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'YES',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        // pop out simply
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'NO',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'JournalMax',
                  style: GoogleFonts.courierPrime(
                      fontSize: 30, color: Colors.white),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(4.0, 16.0, 8.0, 4.0),
                  child: Text(
                    'minimalist',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          backgroundColor: Colors.black54,
          child: ListView(
            padding: const EdgeInsets.only(top: 50.0),
            children: [
              FutureBuilder<String?>(
                future: AuthHelperLocal.getUserEmail(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text(
                        'email id loading...',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const ListTile(
                      title: Text(
                        'Error loading user email',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    final String email = snapshot.data ?? 'hello, Minimalist!';
                    return ListTile(
                      title: Text(
                        email,
                        style: GoogleFonts.courierPrime(
                            fontSize: 18,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                title: const Text(
                  'Sign out',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  FirebaseUIAuth.signOut();
                  AuthHelperLocal.removeUserEmail();
                },
              ),
              ListTile(
                title: const Text(
                  'Reports & Suggestions',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _sendReportEmail();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'Delete all local user data permanently',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _popupDeleteWarning();
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            _showDateSelected(),
            Expanded(child: _buildJournalEntriesList()),
            Container(
              color: Colors.yellow,
              child: BottomButtonsWidget(
                onShowCalendar: _showCalendar,
                onProcessAI: _processAI,
                onAddEntry: _addJournalEntry,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showDateSelected() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        DateFormat('MMMM dd yyyy').format(_selectedDate),
        style: const TextStyle(
            color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildJournalEntriesList() {
    return _journalEntries.isEmpty
        ? const Center(
            child: Text(
              'Empty - No entries were made.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        : ListView.builder(
            itemCount: _journalEntries.length,
            itemBuilder: (context, index) {
              final entry = _journalEntries[index];
              return JournalEntryWidget(
                textContent: entry['textContent'],
                timeStamp: entry['timeStamp'],
              );
            },
          );
  }
}

class JournalEntryWidget extends StatelessWidget {
  final String textContent;
  final String timeStamp;

  const JournalEntryWidget({
    super.key,
    required this.textContent,
    required this.timeStamp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onLongPress: () {
      //   _showPopupMenu(context);
      // },
      child: Card(
        color: Colors.black38,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // timeStamp,
                DateFormat.jm().format(DateTime.parse(timeStamp)),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                textContent,
                style: GoogleFonts.courierPrime(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
