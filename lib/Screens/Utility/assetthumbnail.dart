import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    super.key,
    required this.asset,
  });
  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asset.thumbnailData.then((value) => value!),
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) {
          return const CupertinoActivityIndicator();
        }
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}
