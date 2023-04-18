import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().appGreen,
      appBar: AppBar(
        backgroundColor: CoreColor().appGreen,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: CoreColor().appGreen,
          ),
        ),
        title: Row(
          children: <Widget>[
            const SizedBox(
              width: 40,
              height: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Dr.Anthony Zhong",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Online now",
                  style: TextStyle(
                    color: CoreColor().appGreen,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          Icon(
            Icons.videocam,
            color: CoreColor().appGreen,
            size: 25,
          ),
          const SizedBox(
            width: 15,
          ),
          Icon(
            Icons.call,
            color: CoreColor().appGreen,
            size: 25,
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      body: getBody(),
    );
  }

  var userInfo = {
    'image': 'assets/images/doctor.jpg',
    'name': 'Dr.Anthony Zhong',
    'follewer': '113.154 followers',
    'text': 'How the children should be placed along the',
  };
  Widget getBody() {
    if (messages[0]['image'] == null) {
      messages.insert(0, userInfo);
    }
    print(messages);
    return ListView(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 80),
      children: List.generate(
        messages.length,
        (index) {
          return index == 0
              ? userInformation(
                  messages[index]['image'],
                  messages[index]['name'],
                  messages[index]['follewer'],
                  messages[index]['text'])
              : ChatBubble(
                  isMe: messages[index]['isMe'],
                  messageType: messages[index]['messageType'],
                  message: messages[index]['message'],
                  profileImg: messages[index]['profileImg'],
                );
        },
      ),
    );
  }
}

Widget userInformation(img, name, follewer, text) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(80.0),
          child: Image.asset(
            img,
            width: 90,
            height: 90,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          name,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          follewer,
          style: TextStyle(
            color: CoreColor().appGreen,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 12, //  LAST
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings,
              color: CoreColor().appGreen,
              size: 30,
            ),
            Icon(
              Icons.settings,
              color: CoreColor().appGreen,
              size: 30,
            ),
            Icon(
              Icons.settings,
              color: CoreColor().appGreen,
              size: 30,
            ),
          ],
        ),
      ],
    ),
  );
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String profileImg;
  final String message;
  final int messageType;
  const ChatBubble({
    Key? key,
    required this.isMe,
    required this.profileImg,
    required this.message,
    required this.messageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    color: CoreColor().appGreen,
                    borderRadius: getMessageType(messageType)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(profileImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(profileImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: getMessageType(messageType),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  getMessageType(messageType) {
    if (isMe) {
      // start message
      if (messageType == 1) {
        return const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(5),
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        );
      }
      // middle message
      else if (messageType == 2) {
        return const BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        );
      }
      // end message
      else if (messageType == 3) {
        return const BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(30),
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        );
      }
      // standalone message
      else {
        return const BorderRadius.all(Radius.circular(30));
      }
    }
    // for sender bubble
    else {
      // start message
      if (messageType == 1) {
        return const BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(5),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        );
      }
      // middle message
      else if (messageType == 2) {
        return const BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        );
      }
      // end message
      else if (messageType == 3) {
        return const BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        );
      }
      // standalone message
      else {
        return const BorderRadius.all(
          Radius.circular(30),
        );
      }
    }
  }
}

// users message list
List userMessages = [
  {
    "id": 1,
    "name": "Michael Dam",
    "img":
        "https://images.unsplash.com/photo-1571741140674-8949ca7df2a7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "online": true,
    "story": true,
    "message": "How are you doing?",
    "created_at": "1:00 pm"
  },
];

// list of messages
List messages = [
  {
    "isMe": true,
    "messageType": 1,
    "message": "Ubuntu jng hery",
    "profileImg":
        "https://images.unsplash.com/photo-1517070208541-6ddc4d3efbcb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3319&q=80"
  },
  {
    "isMe": false,
    "messageType": 1,
    "message": "me hate you",
    "profileImg":
        "https://images.unsplash.com/photo-1517070208541-6ddc4d3efbcb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3319&q=80"
  },
  {
    "isMe": true,
    "messageType": 1,
    "message": "Som muk",
    "profileImg":
        "https://images.unsplash.com/photo-1517070208541-6ddc4d3efbcb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3319&q=80"
  },
  {
    "isMe": false,
    "messageType": 1,
    "message": "Eng use ah laptop nus ubuntu",
    "profileImg":
        "https://images.unsplash.com/photo-1517070208541-6ddc4d3efbcb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3319&q=80"
  },
  {
    "isMe": true,
    "messageType": 4,
    "message": "Oh hahahah good",
    "profileImg":
        "https://images.unsplash.com/photo-1517070208541-6ddc4d3efbcb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3319&q=80"
  },
  {
    "isMe": false,
    "messageType": 4,
    "message":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
    "profileImg":
        "https://images.unsplash.com/photo-1517070208541-6ddc4d3efbcb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=3319&q=80"
  }
];
