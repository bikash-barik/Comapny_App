import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../booking/booking_location_page.dart';
import '../../utils/common_helper.dart';
import '../../utils/constant_colors.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard(
      {Key? key,
      required this.cc,
      required this.imageLink,
      required this.title,
      required this.sellerName,
      required this.buttonText,
      required this.rating,
      required this.price,
      required this.width,
      required this.marginRight})
      : super(key: key);

  final ConstantColors cc;
  final imageLink;
  final title;
  final sellerName;
  final buttonText;
  final rating;
  final price;
  final width;
  final marginRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      margin: EdgeInsets.only(
        right: marginRight,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: cc.borderColor),
          borderRadius: BorderRadius.circular(9)),
      padding: const EdgeInsets.fromLTRB(13, 15, 13, 8),
      child: Column(
        children: [
          ServiceCardContents(
              cc: cc,
              imageLink: imageLink,
              title: title,
              sellerName: sellerName,
              rating: rating,
              price: price),
          const SizedBox(
            height: 28,
          ),
          CommonHelper().dividerCommon(),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    AutoSizeText(
                      'Starts from:',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cc.greyFour.withOpacity(.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    AutoSizeText(
                      '\$ $price',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cc.greyFour,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: cc.borderColor),
                    borderRadius: BorderRadius.circular(5)),
                child: SvgPicture.asset(
                  'assets/svg/saved-icon.svg',
                  color: cc.greyFour,
                  height: 21,
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: cc.primaryColor, elevation: 0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const BookingLocationPage(),
                      ),
                    );
                  },
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.normal),
                  ))
            ],
          )
        ],
      ),
    );
  }
}

class ServiceCardContents extends StatelessWidget {
  const ServiceCardContents(
      {Key? key,
      required this.cc,
      required this.imageLink,
      required this.title,
      required this.sellerName,
      required this.rating,
      required this.price})
      : super(key: key);

  final ConstantColors cc;
  final imageLink;
  final title;
  final sellerName;
  final rating;
  final price;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CommonHelper().profileImage(imageLink, 75, 78),
            Positioned(
                bottom: -13,
                left: 12,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      color: const Color(0xffFFC300),
                      borderRadius: BorderRadius.circular(4)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(children: [
                    Icon(
                      Icons.star_border,
                      color: cc.greyFour,
                      size: 14,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      rating,
                      style: TextStyle(
                          color: cc.greyFour,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    )
                  ]),
                )),
          ],
        ),
        const SizedBox(
          width: 13,
        ),
        Expanded(
          child: Column(
            children: [
              //service name ======>
              Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: cc.greyFour,
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),

              //Author name
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'by:',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cc.greyFour.withOpacity(.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    sellerName,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cc.greyFour,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}