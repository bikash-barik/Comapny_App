import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/home_services/category_service.dart';
import 'package:qixer/view/home/categories/components/category_card.dart';
import 'package:qixer/view/services/service_by_category_page.dart';
import 'package:qixer/view/utils/constant_colors.dart';
import 'package:qixer/view/utils/others_helper.dart';

class Categories extends StatelessWidget {
  const Categories({
    Key? key,
    required this.cc,
  }) : super(key: key);
  final ConstantColors cc;

  @override
  Widget build(BuildContext context) {
    // getLineAwsome("las la-charging-station");
    return Consumer<CategoryService>(
      builder: (context, provider, child) {
        return provider.categories != null
            ? provider.categories != 'error'
                ? Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      children: [
                        for (int i = 0;
                            i < provider.categories.category.length;
                            i++)
                          CategoryCard(
                            name: provider.categories.category[i].name,
                            id: provider.categories.category[i].id,
                            cc: cc,
                            index: i,
                            marginRight: 17.0,
                          )
                      ],
                    ),
                  )
                : const Text("Something went wrong")
            : OthersHelper().showLoading(cc.primaryColor);
      },
    );
  }
}
