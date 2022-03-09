import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:get/get.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageTextController = TextEditingController();
  String chatRoomId = Get.arguments[0];

  @override
  void initState() {
    // TODO: implement initState
    debugPrint('Chatroom id is, $chatRoomId');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navBG,
      appBar: _customAppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //     height: 30,
                    //     width: 30,
                    //     decoration: BoxDecoration(
                    //       color: Colors.lightBlue,
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //     child: Icon(
                    //       Icons.add,
                    //       color: Colors.white,
                    //       size: 20,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageTextController,
                        decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: kPrimaryColor,
                      elevation: 0,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _customAppBar() {
    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 4), // 오묘하게 센터가 안맞아서 그냥 넣어줌
        child: const Text(
          'Friend chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}
