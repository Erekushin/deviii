import 'package:devita/helpers/core_url.dart';
import 'package:devita/helpers/gvariables.dart';
import 'package:devita/screens/chat/video_view_page.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key? key,
    required this.message,
    required this.typeMessage,
  }) : super(key: key);
  final String message;
  final String typeMessage;
  final bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: typeMessage == 'remove'
            ? SizedBox(
                width: GlobalVariables.gWidth,
                child: const Center(
                  child: Text(
                    'Call ended',
                  ),
                ),
              )
            : Card(
                elevation: 1,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                color: CoreColor().appGreen.withOpacity(0.8),
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(
                  children: [
                    typeMessage == 'text'
                        ? Container(
                            constraints: const BoxConstraints(
                              maxWidth: 250.0,
                              minWidth: 50.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 6.0),
                            child: Text(
                              message,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : typeMessage == 'image'
                            ? SizedBox(
                                width: 250,
                                height: 250,
                                child: Image.network(
                                    "${CoreUrl.imageUrl}$message"),
                              )
                            : SizedBox(
                                height: 250,
                                width: 250,
                                child: VideoViewPage(
                                  path:
                                      "https://backend.devita.mn/file/?file=$message",
                                ),
                              )
                  ],
                ),
              ),
      ),
    );
  }
}
