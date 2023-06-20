import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        NewContactView.routeName: (context) => const NewContactView(),
      },
    );
  }
}

class ContactBook {
  ContactBook._sharedInstace();
  static final ContactBook _shared = ContactBook._sharedInstace();
  factory ContactBook() => _shared;

  final List<Contact> _contacts = [];

  int get length => _contacts.length;

  void add({required Contact contact}) => _contacts.add(contact);

  void remove({required Contact contact}) => _contacts.remove(contact);
  
  Contact? contact({required int atIndex}) => _contacts.length > atIndex ? _contacts[atIndex] : null;
}

class Contact {
  final String name;

  const Contact({required this.name});
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactBook contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: ListView.builder(
        itemCount: ContactBook().length,
        itemBuilder: (context, index) {
          final Contact contact = contactBook.contact(atIndex: index)!;

          return ListTile(
            title: Text(contact.name),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NewContactView.routeName),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});
  static String routeName = "/new_contact";
  
  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add a new contact"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              helperText: "Enter a new contact name here..."
            ),
          ),
          TextButton(
            onPressed: (){
                final contact = Contact(name: _controller.text);
                ContactBook().add(contact: contact);
                Navigator.pop(context);
              }, 
            child: const Text("Add contact")
          ),
        ],
      )
    );
  }
}