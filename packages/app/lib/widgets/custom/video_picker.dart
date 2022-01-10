import 'dart:typed_data';

import 'package:flutter/material.dart';

// typedef OnAssetSelected = void Function(AssetEntity entity);

// class PhotoList extends StatefulWidget {
//   final List<AssetEntity> photos;
//   final OnAssetSelected onSelected;
//   final VoidCallback onCancel;
//   PhotoList({this.photos, this.onCancel, this.onSelected});

//   @override
//   _PhotoListState createState() => _PhotoListState();
// }

// class _PhotoListState extends State<PhotoList> {
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           childAspectRatio: 1.0,
//           crossAxisSpacing: 6.0,
//           mainAxisSpacing: 6.0),
//       itemBuilder: _buildItem,
//       itemCount: widget.photos.length,
//       padding: EdgeInsets.all(6.0),
//     );
//   }

//   Widget _buildItem(BuildContext context, int index) {
//     AssetEntity entity = widget.photos[index];
//     return FutureBuilder<Uint8List>(
//       future: entity.thumbData,
//       builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             snapshot.data != null) {
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(6.0),
//             child: InkWell(
//               onTap: () => widget?.onSelected(entity),
//               child: Stack(
//                 children: <Widget>[
//                   Image.memory(
//                     snapshot.data,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: double.infinity,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//         return Center(
//           child: Container(),
//         );
//       },
//     );
//   }
// }
