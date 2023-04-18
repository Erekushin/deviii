import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devita/controller/comment_controller.dart';
import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/services/services.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/route_manager.dart';
import 'package:devita/helpers/global_words.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({Key? key, required this.item}) : super(key: key);

  final Object item;

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  static final CommentController _commentController =
      Get.put(CommentController());
  var item;
  List comments = [].obs;
  String commentText = "";

  @override
  void initState() {
    item = widget.item;
    super.initState();
    comments.insert(0, item);
    getComments();
  }

  getComments() {
    var bodyData = {"news_id": item['id']};
    Services()
        .postRequest(
            json.encode(bodyData), '${CoreUrl.baseUrl}news/comments', true)
        .then(
      (data) {
        var response = json.decode(data.body);
        setState(
          () {
            comments.addAll(response['result']['items']);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreColor().backgroundNew,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: CoreColor().appbarColor,
          title: Text(
            'r101343'.coreTranslationWord(),
          ),
          titleSpacing: 0.0,
          elevation: 1,
          centerTitle: true,
          actions: null,
        ),
      ),
      body: InkWell(
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(FocusNode());
          });
        },
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: ListView(
                  padding: const EdgeInsets.all(5),
                  children: List.generate(
                    comments.length,
                    (index) {
                      return index == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: CoreColor().backgroundContainer,
                                    border: const Border(
                                      bottom: BorderSide(
                                          color: Colors.white30, width: 0.5),
                                      top: BorderSide(
                                          color: Colors.white30, width: 0.5),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: null,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['created_date'].substring(0, 10),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(color: Colors.white38),
                                        const SizedBox(height: 10),
                                        Text(
                                          comments[index]['title'],
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          comments[index]['body'],
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  likePostComment(true, index);
                                                },
                                                icon: comments[index]
                                                            ['liked'] ==
                                                        0
                                                    ? const Icon(
                                                        Icons.favorite_border)
                                                    : const Icon(
                                                        Icons.favorite)),
                                            Text(
                                              '${comments[index]['likes_count']}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                    'Comments (${comments.length - 1})',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: const Divider(color: Colors.white),
                                ),
                              ],
                            )
                          : Container(
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: comments[index]['user']
                                              ['profile_image'] ==
                                          null
                                      ? Image.asset(
                                          'assets/images/logo_color1.png',
                                          fit: BoxFit.fitHeight,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: CoreUrl.imageUrl +
                                              comments[index]['user']
                                                  ["profile_image"],
                                          fit: BoxFit.fitWidth,
                                          width: 40,
                                          height: 40,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "assets/images/userprofile.png"),
                                        ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comments[index]['user']
                                                  ["first_name"] +
                                              ' ' +
                                              comments[index]['user']
                                                  ["last_name"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          comments[index]['created_date']
                                              .toString()
                                              .toNormalDate(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            color: Colors.white24,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          comments[index]['like_count']
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 12,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              likePostComment(false, index);
                                            },
                                            icon: comments[index]['liked'] == 0
                                                ? const Icon(
                                                    Icons.favorite_border)
                                                : const Icon(Icons.favorite))
                                      ],
                                    )
                                  ],
                                ),
                                subtitle: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        comments[index]['comment'].toString(),
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.white38,
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: 50,
                  width: GlobalVariables.gWidth,
                  child: Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                      onChanged: (value) {
                        commentText = value;
                      },
                      controller: _commentController.commentTextController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1.0),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1.0),
                        ),
                        hintText: "Write your comment",
                        hintStyle: const TextStyle(color: Colors.white38),
                        contentPadding: const EdgeInsets.all(5),
                        suffixIcon: IconButton(
                          onPressed: () {
                            writeComment();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  likePostComment(boolean, index) {
    var bodyData = {};
    if (boolean) {
      var data = {
        'news_id': comments[index]['id'].toString(),
      };
      bodyData = data;
    } else {
      var data = {
        'news_id': '',
        'comment_id': comments[index]['id'].toString(),
      };
      bodyData = data;
    }

    Services()
        .postRequest(json.encode(bodyData), '${CoreUrl.baseUrl}news/like', true)
        .then((data) {
      var res = json.decode(data.body);
      if (res['code'] == 200) {
        setState(() {
          if (boolean) {
            comments[index]['liked'] = comments[index]['liked'] == 0 ? 1 : 0;
            comments[index]['likes_count'] = comments[index]['liked'] == 0
                ? comments[index]['likes_count'] - 1
                : comments[index]['likes_count'] + 1;
          } else {
            comments[index]['liked'] = comments[index]['liked'] == 0 ? 1 : 0;
            comments[index]['like_count'] = comments[index]['liked'] == 0
                ? comments[index]['like_count'] - 1
                : comments[index]['like_count'] + 1;
          }
        });
      } else {
        Get.snackbar(
          gWarning,
          res['message'],
          colorText: Colors.black,
        );
      }
    });
  }

  writeComment() {
    var bodyData = {
      "news_id": item['id'],
      "comment": commentText,
    };
    if (commentText != "") {
      Services()
          .postRequest(
              json.encode(bodyData), '${CoreUrl.baseUrl}news/comment', true)
          .then((data) {
        var res = json.decode(data.body);
        if (res['code'] == 200) {
          _commentController.clean();
          setState(() {
            comments.add(res['result']);
          });
        } else {
          Get.snackbar(
            gWarning,
            res['message'],
            colorText: Colors.black,
          );
        }
      });
    }
  }
}
