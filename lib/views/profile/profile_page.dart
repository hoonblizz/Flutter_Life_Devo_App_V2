import 'package:flutter/material.dart';
import 'package:flutter_life_devo_app_v2/controllers/global_controller.dart';
import 'package:flutter_life_devo_app_v2/controllers/profile/profile_controller.dart';
import 'package:flutter_life_devo_app_v2/models/friend_request_model.dart';
import 'package:flutter_life_devo_app_v2/theme/app_colors.dart';
import 'package:flutter_life_devo_app_v2/theme/app_sizes.dart';
import 'package:flutter_life_devo_app_v2/views/widgets/loading_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class ProfilePage extends StatelessWidget {
  //const ProfilePage({Key? key}) : super(key: key);
  final GlobalController _gc = Get.find<GlobalController>();
  final ProfileController _profileCtrler = Get.find();

  final TextEditingController _controllerInviteFriend = TextEditingController();

  onPressInviteFriend() {
    Get.defaultDialog(
      title: "Enter email",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controllerInviteFriend,
            keyboardType: TextInputType.text,
            maxLines: 1,
            decoration: const InputDecoration(
              labelText: 'Email',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            ),
            onPressed: () {
              if (_controllerInviteFriend.text.isNotEmpty) {
                debugPrint('Send a request! ${_controllerInviteFriend.text}');
                _profileCtrler
                    .onPressInviteFriend(_controllerInviteFriend.text);
                _controllerInviteFriend.text = "";
              }
              Get.back();
            },
            child: Text(
              'Send a request',
              style: TextStyle(
                fontSize: mainPageContentsDesc,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenPaddingHorizontal,
          ),
          child: SingleChildScrollView(
            //physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: screenPaddingVertical,
                ),
                // Life devo title
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: mainPageContentsTitle,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(.8),
                    ),
                  ),
                ),
                SizedBox(
                  height: mainPageContentsSpace * 10,
                ),

                // Invite button
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                    ),
                    onPressed: onPressInviteFriend,
                    child: Text(
                      'Invite a friend',
                      style: TextStyle(
                          fontSize: mainPageContentsDesc,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                SizedBox(
                  height: mainPageContentsSpace,
                ),

                // Friend request list
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      //width: double.infinity,
                      child: Text(
                        'Friend Requests',
                        style: TextStyle(
                          fontSize: mainPageContentsTitle,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh,
                          size: 32, color: kPrimaryColor),
                      onPressed: _profileCtrler.getFriendRequests,
                    ),
                  ],
                ),
                Obx(() {
                  //List<FriendRequestModel> _requestList = _profileCtrler.friendRequestList;

                  if (_profileCtrler.isRequestLoading.value) {
                    return const LoadingWidget();
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _profileCtrler.friendRequestList
                        .map((FriendRequestModel el) {
                      // is request from me?
                      bool isFromMe =
                          el.fromUser.userId == _gc.currentUser.userId;
                      debugPrint('Current user: ${_gc.currentUser.userId}');
                      return ListTile(
                        title: Text(
                            isFromMe
                                ? "Request to " + el.toUser.name
                                : "Request from " + el.fromUser.name,
                            style: TextStyle(fontSize: friendRequestUserName)),
                        subtitle: Text(
                          DateFormat.yMMMEd().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                el.lastModifiedEpoch),
                          ),
                          style: TextStyle(fontSize: friendRequestDate),
                        ),
                        trailing: isFromMe
                            ? TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  primary: Colors.white,
                                  backgroundColor: kSecondaryColor,
                                ),
                                onPressed: () {
                                  _profileCtrler.onPressDeclineFriendRequest(
                                      el.skCollection);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Row(mainAxisSize: MainAxisSize.min, children: [
                                // IconButton(onPressed: () => {}, icon: Icon(Icons.))
                                TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    primary: Colors.white,
                                    backgroundColor: kPrimaryColor,
                                  ),
                                  onPressed: () {
                                    _profileCtrler.onPressAcceptFriendRequest(
                                        el.skCollection,
                                        el.fromUserId,
                                        el.toUserId);
                                  },
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    primary: Colors.white,
                                    backgroundColor: kSecondaryColor,
                                  ),
                                  onPressed: () {
                                    _profileCtrler.onPressDeclineFriendRequest(
                                        el.skCollection);
                                  },
                                  child: const Text(
                                    'Decline',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ]),
                      );
                    }).toList(),
                  );
                })

                // Life devo content
                // Obx(() {
                //   if (_mainController.latestLifeDevoSession.value
                //       .pkCollectionSession.isNotEmpty) {
                //     return LatestLifeDevo(
                //       _mainController.latestLifeDevoSession.value,
                //     );
                //   }
                //   return Container();
                // })
              ],
            ),
          ),
        ),
        // Obx(() {
        //   return _mainController.isHomeTabLoading.value
        //       ? const LoadingWidget()
        //       : Container();
        // })
      ],
    );
  }
}
