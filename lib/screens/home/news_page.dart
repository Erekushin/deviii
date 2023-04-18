import 'dart:convert';

import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/home/home_page.dart';
import 'package:devita/screens/user_views/news/news_details.dart';
import 'package:devita/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:devita/style/color.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List items = [].obs;
  @override
  void initState() {
    super.initState();
    getNewsList();
  }

  getNewsList() {
    var bodyData = {"lang": "en", "page_number": 1, "page_size": 10};
    Services()
        .postRequest(json.encode(bodyData), '${CoreUrl.baseUrl}news/list', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(
          () {
            items = response['result']['items'];
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CoreColor().backgroundNew,
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(60.0),
        //   child: AppBar(
        //     centerTitle: true,
        //     backgroundColor: CoreColor().appbarColor,
        //     automaticallyImplyLeading: false,
        //     title: Text('r101176'.coreTranslationWord()),
        //     elevation: 1,
        //   ),
        // ),
        body: ListView.builder(
          itemBuilder: (con, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  //newsDetail(index);
                  Get.to(() => NewsDetail(item: items[index]));
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: CoreColor().backgroundContainer,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: ListTile(
                  leading: null,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        items[index]['created_date'].substring(0, 10),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'r101342'.coreTranslationWord(),
                        style: TextStyle(
                          color: CoreColor().appGreen,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.white38),
                      const SizedBox(height: 10),
                      Text(
                        items[index]['title'],
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        items[index]['body'],
                        textAlign: TextAlign.justify,
                        maxLines: 5,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              items[index]['liked'] == 0
                                  ? const Icon(Icons.favorite_border)
                                  : const Icon(Icons.favorite),
                              const SizedBox(width: 5),
                              Text(
                                '${items[index]['likes_count']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Comments ${items[index]['comments_count']}',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: items.length,
          shrinkWrap: true,
          padding: const EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
        ));
  }

  // newsDetail(index) {
  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     enableDrag: false,
  //     builder: (context) {
  //       return SizedBox(
  //         height: GlobalVariables.gHeight - 0,
  //         child: Scaffold(
  //           resizeToAvoidBottomInset: false,
  //           backgroundColor: CoreColor().backgroundNew,
  //           appBar: PreferredSize(
  //             preferredSize: const Size.fromHeight(60.0),
  //             child: AppBar(
  //               automaticallyImplyLeading: true,
  //               backgroundColor: CoreColor().appbarColor,
  //               title: Text('r101176'.coreTranslationWord()),
  //               titleSpacing: 0.0,
  //               elevation: 1,
  //               centerTitle: true,
  //               actions: null,
  //             ),
  //           ),
  //           body: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const SizedBox(height: 10),
  //               Container(
  //                 padding: const EdgeInsets.only(top: 10, bottom: 10),
  //                 decoration: BoxDecoration(
  //                   color: CoreColor().backgroundContainer,
  //                   border: const Border(
  //                     bottom: BorderSide(color: Colors.white30, width: 0.5),
  //                     top: BorderSide(color: Colors.white30, width: 0.5),
  //                   ),
  //                 ),
  //                 child: ListTile(
  //                   leading: null,
  //                   title: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         items[index]['created_date'].substring(0, 10),
  //                         style: const TextStyle(
  //                           color: Colors.white38,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                       Text(
  //                         'Website link',
  //                         style: TextStyle(
  //                           color: CoreColor().appGreen,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   subtitle: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Divider(color: Colors.white38),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         items[index]['title'],
  //                         textAlign: TextAlign.start,
  //                         style: const TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 14,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         items[index]['body'],
  //                         textAlign: TextAlign.justify,
  //                         style: const TextStyle(
  //                           color: Colors.white38,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Row(
  //                         children: [
  //                           const Icon(Icons.favorite_border),
  //                           const SizedBox(width: 5),
  //                           Text(
  //                             '${items[index]['likes_count']}',
  //                             style: const TextStyle(
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 15),
  //               Container(
  //                 margin: const EdgeInsets.only(left: 10, right: 10),
  //                 child: Text(
  //                   'Comments ${items[index]['comments_count']}',
  //                   style: const TextStyle(
  //                     color: Colors.white38,
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 margin: const EdgeInsets.only(left: 10, right: 10),
  //                 child: const Divider(color: Colors.white38),
  //               ),
  //               SizedBox(
  //                 height: GlobalVariables.gHeight / 3,
  //                 child: commentList(),
  //               ),
  //               const SizedBox(height: 15),
  //               Container(
  //                 margin: const EdgeInsets.only(left: 10, right: 10),
  //                 child: const Divider(color: Colors.white38),
  //               ),
  //               TextFormField(
  //                 textAlignVertical: TextAlignVertical.center,
  //                 maxLines: 5,
  //                 minLines: 1,
  //                 onChanged: (value) {},
  //                 decoration: const InputDecoration(
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.all(
  //                       Radius.circular(12.0),
  //                     ),
  //                     borderSide:
  //                         BorderSide(color: Colors.coreTranslationWord()ansparent, width: 1.0),
  //                   ),
  //                   disabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.all(
  //                       Radius.circular(12.0),
  //                     ),
  //                     borderSide:
  //                         BorderSide(color: Colors.coreTranslationWord()ansparent, width: 1.0),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.all(
  //                       Radius.circular(12.0),
  //                     ),
  //                     borderSide:
  //                         BorderSide(color: Colors.coreTranslationWord()ansparent, width: 1.0),
  //                   ),
  //                   hintText: "Write your comment",
  //                   hintStyle: TextStyle(color: Colors.white38),
  //                   contentPadding: EdgeInsets.all(5),
  //                   suffix: Text('COMMENT'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget commentList() {
  //   return ListView.builder(
  //     itemBuilder: (con, index) {
  //       return Container(
  //         margin: const EdgeInsets.only(left: 10, right: 10),
  //         padding: const EdgeInsets.only(top: 10, bottom: 10),
  //         child: ListTile(
  //             leading: ClipRRect(
  //               borderRadius: BorderRadius.circular(60.0),
  //               child: Image.asset(
  //                 'assets/images/logo_color1.png',
  //                 fit: BoxFit.fitHeight,
  //               ),
  //             ),
  //             title: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: const [
  //                     Text(
  //                       'Dr. John Appleseed',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 13,
  //                       ),
  //                     ),
  //                     SizedBox(height: 5),
  //                     Text(
  //                       "1 hour ago",
  //                       textAlign: TextAlign.start,
  //                       style: TextStyle(
  //                         color: Colors.white24,
  //                         fontSize: 10,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: const [
  //                     Text(
  //                       '4',
  //                       style: TextStyle(
  //                         color: Colors.white38,
  //                         fontSize: 12,
  //                       ),
  //                     ),
  //                     SizedBox(width: 5),
  //                     Icon(
  //                       Icons.favorite_border,
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //             subtitle: Column(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.only(top: 10),
  //                   child: const Text(
  //                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
  //                     style: TextStyle(
  //                       color: Colors.white54,
  //                       fontSize: 10,
  //                     ),
  //                   ),
  //                 ),
  //                 const Divider(
  //                   color: Colors.white38,
  //                 ),
  //               ],
  //             )),
  //       );
  //     },
  //     itemCount: items.length,
  //     shrinkWrap: true,
  //     padding: const EdgeInsets.all(5),
  //     scrollDirection: Axis.vertical,
  //   );
  // }
}
