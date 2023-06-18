import 'package:e_lugstore/constants/constants.dart';
import 'package:flutter/material.dart';

import '../widgets/navdrawer.dart';

class Background extends StatefulWidget {
  final bool? isStaff;
  final bool? isHomePage;
  final bool hasAction;
  final bool hasDrawer;
  final String pageTitle;
  final String assetImage;
  final IconData? icon;
  final IconData? fabIcon;
  final IconData? actionIcon;
  final Function()? fabFunc;
  final Function()? appBarLeading;
  final Function()? actionButtonFunc;
  final Widget child;
  const Background({
    super.key,
    required this.pageTitle,
    required this.assetImage,
    this.icon,
    this.appBarLeading,
    required this.child,
    required this.hasDrawer,
    this.isStaff,
    this.fabIcon,
    this.fabFunc,
    required this.isHomePage,
    required this.hasAction,
    this.actionIcon,
    this.actionButtonFunc,
  });

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.isHomePage!
            ? FloatingActionButton(
                backgroundColor: accent,
                onPressed: widget.fabFunc,
                child: widget.isHomePage!
                    ? Icon(
                        widget.fabIcon,
                        color: Colors.white,
                      )
                    : null)
            : null,
        // resizeToAvoidBottomInset: false,
        drawer: widget.hasDrawer
            ? NavDrawer(
                isStaff: widget.isStaff,
              )
            : null,
        appBar: AppBar(
          actions: widget.hasAction
              ? [
                  IconButton(
                    onPressed: widget.actionButtonFunc,
                    icon: Icon(
                      widget.actionIcon,
                      color: Colors.black,
                    ),
                  )
                ]
              : null,
          centerTitle: true,
          automaticallyImplyLeading: widget.hasDrawer ? true : false,
          leading: widget.hasDrawer
              ? null
              : IconButton(
                  onPressed: widget.appBarLeading,
                  icon: Icon(
                    widget.icon,
                    size: 30,
                  ),
                ),
          title: Text(
            widget.pageTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 1.0,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: MediaQuery.of(context).size.width / 2 - 125,
              width: 250,
              height: 250,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.assetImage),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Center(
              child: widget.child,
            )
          ],
        ));
  }
}
