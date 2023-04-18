import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    // required this.chatModel,
  }) : super(key: key);
  // final chatModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Image.asset('assets/images/user_profile.png'),
              backgroundColor: Colors.blueGrey,
            ),
            title: const Text(
              'Манлай',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: const [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'Сайн байна уу?',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: const Text('16:00'),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
