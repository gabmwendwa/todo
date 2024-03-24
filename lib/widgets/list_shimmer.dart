import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:to_do/core/constants.dart';

class ListShimmer extends StatelessWidget {
  final double height;
  const ListShimmer({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 3.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.secondary,
              highlightColor: Theme.of(context).colorScheme.primary,
              enabled: true,
              child: ListView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // <-- this will disable scroll
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                itemCount: doubletoint(MediaQuery.of(context).size.height / 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
