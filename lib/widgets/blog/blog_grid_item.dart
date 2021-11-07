import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/constants.dart' show RouteList;
import '../../common/tools.dart';
import '../../models/entities/blog.dart';
import '../../routes/flux_navigate.dart';

class BlogGridItem extends StatelessWidget {
  final Blog blog;

  const BlogGridItem({required this.blog});

  @override
  Widget build(BuildContext context) {
    var myLocale = Localizations.localeOf(context);
    var dateFormat;

    if (myLocale == const Locale('il', '')) {
      dateFormat = DateFormat(DateFormat.YEAR_MONTH_DAY, 'en');
    } else {
      dateFormat = DateFormat(DateFormat.YEAR_MONTH_DAY);
    }

    final createAt =
        dateFormat.format(DateTime.tryParse(blog.date!) ?? DateTime.now());

    return InkWell(
      onTap: () => FluxNavigate.pushNamed(
        RouteList.detailBlog,
        arguments: blog,
      ),
      child: Transform.translate(
        offset: const Offset(40, 0),
        child: Container(
          // color: Colors.green,
          padding: const EdgeInsets.all(5
              // bottom: 6.0,
              // left: 16.0,
              ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: ImageTools.image(
                  url: blog.imageFeature,
                  size: kSize.medium,
                  isVideo:
                      Videos.getVideoLink(blog.content!) == null ? false : true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      blog.title ?? '',
                      maxLines: 2,
                      style: const TextStyle(fontSize: 17.0),
                    ),
                    if (blog.date != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          blog.date ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
