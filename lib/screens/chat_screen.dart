import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatScreen extends StatelessWidget {
  static String routeName = "ChatScreen";
  final controllerScroll = ScrollController();
  String? messageData ;

  CollectionReference messages = FirebaseFirestore.instance.collection(kMessagesCollection);

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot)
      {
        if(snapshot.hasData)
        {
          List<Message> messagesList = [];
          for(int i = 0 ; i < snapshot.data!.docs.length ; i++)
          {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kLogo, height: 50,),
                  Text('Chat'),
                ],
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: controllerScroll,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index)
                    {
                      return messagesList[index].id == email ?
                      ChatBuble(message: messagesList[index],)
                      :ChatBubleFromFriend(message: messagesList[index],);
                    },

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controller,
                    onChanged: (data)
                    {
                      messageData = data;
                    },
                    onSubmitted: (data)
                    {
                      if(data.isEmpty)
                      {
                        showSnackBar(context, "You cannot send an empty message");
                      }
                      else
                      {
                        messages.add({
                          kId: email,
                          kMessages:data,
                          kCreatedAt : DateTime.now(),
                        });
                      }
                      controller.clear();
                      controllerScroll.animateTo(
                        0,
                        duration: Duration(microseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Send Message',
                      suffixIcon: IconButton(
                        onPressed: ()
                        {
                          if(messageData!.isEmpty)
                          {
                            showSnackBar(context, "You cannot send an empty message");
                          }
                          else
                          {
                            messages.add({
                              kId: email,
                              kMessages:messageData,
                              kCreatedAt : DateTime.now(),
                            });
                          }
                          controller.clear();
                          messageData = '';
                          controllerScroll.animateTo(
                            0,
                            duration: Duration(microseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: Icon(Icons.send, color: kPrimaryColor,),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else
        {
          return ModalProgressHUD(
            inAsyncCall: true,
            child: Scaffold(),
          );
        }
      },
    );
  }
}
