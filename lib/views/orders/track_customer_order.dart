// import 'package:flutter/material.dart';
//
// import '../../colors/color_palette.dart';
//
// class TrackCustomerOrder extends StatelessWidget {
//   const TrackCustomerOrder({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffD0D7D4),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         foregroundColor: kNew9a,
//         title: Text('Order Tracking',
//             style: TextStyle(
//                 color: kNew9a,
//                 fontSize: 20,
//                 letterSpacing: 0,
//                 fontWeight: FontWeight.w500)),
//       ),
//       body: ,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../../colors/color_palette.dart';

class TrackCustomerOrder extends StatelessWidget {
  final List<String> statuses = [
    'New Order',
    'In Progress',
    'Pending',
    'Completed',
    'Handed Over'
  ];

  final String currentStatus; // Pass the current order status

  TrackCustomerOrder({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD0D7D4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kNew9a,
        title: Text('Order Tracking',
            style: TextStyle(
                color: kNew9a,
                fontSize: 20,
                letterSpacing: 0,
                fontWeight: FontWeight.w500)),
      ),
      body:  Container(
        padding: EdgeInsets.all(16.0),
        child: FixedTimeline.tileBuilder(
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: statuses.length,
            contentsBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  statuses[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: getStatusTextColor(statuses[index]),
                  ),
                ),
              );
            },
            indicatorBuilder: (context, index) {
              return DotIndicator(
                size: statuses[index] == currentStatus ? 30.0 : 20.0,
                color: getStatusColor(statuses[index]),
                child: statuses[index] == currentStatus
                    ? Icon(Icons.check, color: Colors.white)
                    : null,
              );
            },
            connectorBuilder: (context, index, type) {
              return SolidLineConnector(
                color: index < statuses.indexOf(currentStatus)
                    ? Colors.green
                    : Colors.grey.shade400,
                thickness: 4.0,
              );
            },
          ),
        ),
      ),
    );


  }

  // Set Color Based on Status
  Color getStatusColor(String status) {
    if (status == currentStatus) return Colors.blue;
    if (statuses.indexOf(status) < statuses.indexOf(currentStatus)) {
      return Colors.green; // Completed statuses
    }
    return Colors.grey; // Upcoming statuses
  }

  // Set Text Color Based on Status
  Color getStatusTextColor(String status) {
    if (status == currentStatus) return Colors.blue;
    if (statuses.indexOf(status) < statuses.indexOf(currentStatus)) {
      return Colors.green; // Completed statuses
    }
    return Colors.black54; // Upcoming statuses
  }
}