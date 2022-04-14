import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageBig extends StatelessWidget {
  const ImageBig({Key? key, required this.serviceName, required this.imageLink})
      : super(key: key);
  final serviceName;
  final imageLink;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: 310,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: imageLink,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            )),
        Container(
          height: 310,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.7),
                  Colors.black.withOpacity(.1)
                ]),
          ),
        ),
        Positioned(
            left: 10,
            top: 55,
            right: 30,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.white,
                  iconSize: 19,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 4),
                  child: Text(
                    serviceName,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
