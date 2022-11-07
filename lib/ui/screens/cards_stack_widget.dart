import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_app_new/core/constant/color_constant.dart';
import 'package:tinder_app_new/core/enum/viewstate.dart';

import '../../core/model/cards_model.dart';
import 'drag_widget.dart';

class CardsStackWidget extends StatefulWidget {
  const CardsStackWidget({Key? key}) : super(key: key);

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget> with SingleTickerProviderStateMixin {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  List<ProfilePicture> list = [];
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        list.removeLast();
        _animationController.reset();

        swipeNotifier.value = Swipe.none;
      }
    });
  }

  getImages() async {
    // list.clear();
    var data = await firebase.collection('Users').get();
    for (int i = 0; i < data.docs.length; i++) {
      ProfilePicture model = ProfilePicture(data.docs[i].data()['image_url'], data.docs[i].data()['name'], data.docs[i].data()['gender'],
          data.docs[i].data()['id'], data.docs[i].data()['isFavourite']);
      list.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FutureBuilder(
            future: getImages(),
            builder: (BuildContext context, snapshot) {
              /*     if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Something went wrong",
                  ),
                );
              }*/
              if (snapshot.connectionState == ConnectionState.done) {
                return ValueListenableBuilder(
                  valueListenable: swipeNotifier,
                  builder: (context, swipe, _) => Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: List.generate(list.length, (index) {
                        if (index == list.length - 1) {
                          return PositionedTransition(
                            rect: RelativeRectTween(
                              begin: RelativeRect.fromSize(const Rect.fromLTWH(0, 0, 580, 340), const Size(580, 340)),
                              end: RelativeRect.fromSize(
                                  Rect.fromLTWH(
                                      swipe != Swipe.none
                                          ? swipe == Swipe.left
                                              ? -300
                                              : 300
                                          : 0,
                                      0,
                                      580,
                                      340),
                                  const Size(580, 340)),
                            ).animate(CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeInOut,
                            )),
                            child: RotationTransition(
                              turns: Tween<double>(
                                      begin: 0,
                                      end: swipe != Swipe.none
                                          ? swipe == Swipe.left
                                              ? -0.1 * 0.3
                                              : 0.1 * 0.3
                                          : 0.0)
                                  .animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: const Interval(0, 0.4, curve: Curves.easeInOut),
                                ),
                              ),
                              child: DragWidget(
                                profile: list[index],
                                index: index,
                                swipeNotifier: swipeNotifier,
                                isLastCard: true,
                                onPressedLike: () {
                                  swipeNotifier.value = Swipe.right;
                                  _animationController.forward();
                                  addLike(list[index].id);
                                },
                                onPressedCancel: () {
                                  swipeNotifier.value = Swipe.left;
                                  _animationController.forward();
                                },
                              ),
                            ),
                          );
                        } else {
                          return DragWidget(
                            profile: list[index],
                            index: index,
                            swipeNotifier: swipeNotifier,
                            onPressedLike: () {
                              swipeNotifier.value = Swipe.right;
                              _animationController.forward();
                              addLike(list[index].id);
                            },
                            onPressedCancel: () {
                              swipeNotifier.value = Swipe.left;
                              _animationController.forward();
                            },
                          );
                        }
                      })),
                );
              }
              return const Center(child: CircularProgressIndicator(color: ColorConstant.greenLight));
            },
          ),
        ),
        Positioned(
          left: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              list.removeAt(index);
            },
          ),
        ),
        Positioned(
          right: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              list.removeAt(index);
            },
          ),
        ),
      ],
      /*   Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ValueListenableBuilder(
              valueListenable: swipeNotifier,
              builder: (context, swipe, _) => Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: List.generate(draggableItems.length, (index) {
                  if (index == draggableItems.length - 1) {
                    return PositionedTransition(
                      rect: RelativeRectTween(
                        begin: RelativeRect.fromSize(const Rect.fromLTWH(0, 0, 580, 340), const Size(580, 340)),
                        end: RelativeRect.fromSize(
                            Rect.fromLTWH(
                                swipe != Swipe.none
                                    ? swipe == Swipe.left
                                        ? -300
                                        : 300
                                    : 0,
                                0,
                                580,
                                340),
                            const Size(580, 340)),
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      )),
                      child: RotationTransition(
                        turns: Tween<double>(
                                begin: 0,
                                end: swipe != Swipe.none
                                    ? swipe == Swipe.left
                                        ? -0.1 * 0.3
                                        : 0.1 * 0.3
                                    : 0.0)
                            .animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0, 0.4, curve: Curves.easeInOut),
                          ),
                        ),
                        child: DragWidget(
                          profile: draggableItems[index],
                          index: index,
                          swipeNotifier: swipeNotifier,
                          isLastCard: true,
                        ),
                      ),
                    );
                  } else {
                    return DragWidget(
                      profile: draggableItems[index],
                      index: index,
                      swipeNotifier: swipeNotifier,
                    );
                  }
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 46.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActionButtonWidget(
                    onPressed: () {
                      swipeNotifier.value = Swipe.left;
                      _animationController.forward();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ActionButtonWidget(
                    onPressed: () {
                      swipeNotifier.value = Swipe.right;
                      _animationController.forward();
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: DragTarget<int>(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return IgnorePointer(
                  child: Container(
                    height: 700.0,
                    width: 80.0,
                    color: Colors.transparent,
                  ),
                );
              },
              onAccept: (int index) {
                setState(() {
                  draggableItems.removeAt(index);
                });
              },
            ),
          ),
          Positioned(
            right: 0,
            child: DragTarget<int>(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return IgnorePointer(
                  child: Container(
                    height: 700.0,
                    width: 80.0,
                    color: Colors.transparent,
                  ),
                );
              },
              onAccept: (int index) {
                setState(() {
                  draggableItems.removeAt(index);
                });
              },
            ),
          ),
        ],
      ),*/
    );
  }

  addLike(String userId) async {
    await firebase.collection('Users').doc(userId).update({'isFavourite': true});
  }
}
