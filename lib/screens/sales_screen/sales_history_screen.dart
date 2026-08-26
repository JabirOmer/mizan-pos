// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:mizan_pos/constants/animations.dart';
// import 'package:mizan_pos/constants/colors.dart';
// import 'package:mizan_pos/constants/icons.dart';
// import 'package:mizan_pos/constants/sizes.dart';
// import 'package:mizan_pos/helpers/helper_functions.dart';
// import 'package:mizan_pos/models/device_model.dart';
// import 'package:mizan_pos/models/order_data_model.dart';
// import 'package:mizan_pos/models/payment_method_model.dart';
// import 'package:mizan_pos/models/user_model.dart';
// import 'package:mizan_pos/providers/app_info_provider.dart';
// import 'package:mizan_pos/providers/orders_provider.dart';
// import 'package:mizan_pos/providers/payments_provider.dart';
// import 'package:mizan_pos/ui/ui_button_widget.dart';
// import 'package:mizan_pos/ui/ui_loading_screen_widget.dart';
// import 'package:mizan_pos/ui/ui_no_data_founded.dart';
// import 'package:mizan_pos/ui/ui_popup_widget.dart';
// import 'package:mizan_pos/ui/ui_title_widget.dart';
// import 'package:provider/provider.dart';

// class SalesHistoryScreen extends StatefulWidget {
//   const SalesHistoryScreen({super.key});

//   @override
//   State<SalesHistoryScreen> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<SalesHistoryScreen> {
//   late DeviceModel _deviceData;
//   OrderDataModel? _orderToBeLooked;
//   bool _showPaymentsOverview = false;
//   late UserModel _userData;

  
//   // - - - - - - >>
//   // - - - F U N C T I O N S
//   void _handleShowDatePicker(DateTime initialDate) {
//     showDatePicker(
//       context: context, 
//       firstDate: DateTime(2026, DateTime.may), 
//       lastDate: DateTime.now(),
//       initialDate: initialDate
//     ).then((date) {
//       if (date == null) return;
//       _handleDateChange(date);
//     });
//   }

//   void _toggleOrderToBeLooked(OrderDataModel? orderData) {
//     setState(() => _orderToBeLooked = orderData,);
//   }

//   void _toggleShowPaymentsOverview() {
//     setState(() => _showPaymentsOverview = !_showPaymentsOverview,);
//   }

//   void _sendOrderAgain(OrderDataModel orderData) {
//     final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
//     ordersProvider.sendOrderData(orderData: _orderToBeLooked!, branchId: _deviceData.branchId, fromOffline: true);
//     setState(() => _orderToBeLooked = null);
//   }

//   void _handleDateChange(DateTime date) {
//     final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
//     ordersProvider.changeSalesDate(date);
//   }

//   double _calculatePaymentTotal(String paymentId) {
//     final OrdersProvider ordersProvider = Provider.of(context, listen: false);
//     final orderList = ordersProvider.onlineOrderList;
//     double total = 0;
//     for (var order in orderList) {
//       for (var payment in order.orderPayments) { 
//         if (payment.paymentId != paymentId) continue; 
//         total += payment.amount;
//       }
//     }
//     return total;
//   }
//   // - - - F U N C T I O N S
//   // - - - - - - >>

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final appInfoProvider = Provider.of<AppInfoProvider>(context, listen: false);
//     setState(() {
//       _deviceData = appInfoProvider.deviceData!;
//       _userData = appInfoProvider.currentUser!;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<OrdersProvider>(
//         builder: (context, provider, child) {
//           return Stack(
//             children: [

//               // - - - M A I N _ W I N D O W
//               SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: CSizes.largeGap),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       SizedBox(height: CSizes.largeGap,),
                
//                       // Title
//                       UiTitleWidget(text: 'Sales History', bigger: true,),
                      
//                       SizedBox(height: CSizes.largeGap,),
                      
//                       // Toggle
//                       _toggleBetweenOrderListMethod(
//                         showOfflineOrders: provider.showOfflineOrders, 
//                         offlineOrdersCount: provider.offlineOrderList.length, 
//                         onToggleClick: (showOffline) => provider.toggleShowOfflineOrders(showOffline), 
//                         onRefreshClick: provider.fetchOnlineOrders,
//                         salesDate: provider.salesDate,
//                         onDateClick: () => _handleShowDatePicker(provider.salesDate),
//                         onShowPaymentsOverviewClick: _toggleShowPaymentsOverview
//                       ),
                      
//                       SizedBox(height: CSizes.largeGap,),
                  
//                       // Offline Orders
//                       if (provider.showOfflineOrders) _orderHistoryDisplayMethod(
//                         isOnline: false,
//                         orderDataList: provider.offlineOrderList,
//                         onShowMoreClickConnect: (orderData) => _toggleOrderToBeLooked(orderData,),
//                       ),
                  
//                       // Online Orders
//                       if (!provider.showOfflineOrders) Column(
//                         children: [
//                           if (provider.fetchOnlineLoading) UiLoadingScreenWidget(),

//                           if (provider.fetchErrorMessage != null) Center(
//                             child: UiNoDataFounded(
//                               title: provider.fetchErrorMessage,
//                               buttonText: 'search again',
//                               onButtonClick: provider.fetchOnlineOrders,
//                             ),
//                           ),

//                           if (!provider.fetchOnlineLoading && provider.fetchErrorMessage == null) Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [

//                               LayoutBuilder(
//                                 builder: (context, constraints) {
//                                   return SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: ConstrainedBox(
//                                       constraints: BoxConstraints( minWidth: constraints.maxWidth ),
//                                       child: _salesOverViewMethod(
//                                         currentUser: _userData,
//                                         totalOrders: provider.totalOrders,
//                                         totalSales: provider.totalSales,
//                                         totalChange: provider.totalChanges,
//                                         totalCost: provider.totalCost,
//                                         totalProfit: provider.totalProfit,
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               ),

//                               SizedBox(height: CSizes.largeGap,),
                          
//                               _orderHistoryDisplayMethod(
//                                 isOnline: true,
//                                 orderDataList: provider.onlineOrderList, 
//                                 onShowMoreClickConnect: (orderData) => _toggleOrderToBeLooked(orderData),
//                                 searchAgain: provider.fetchOnlineOrders,
//                               )
//                             ],
//                           ),

//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),



//               // // - - - O R D E R _ D E T A I L S
//               // if (_orderToBeLooked != null && !provider.sendOrderLoading) OrderDetailsPoupWidget(
//               //   orderData: _orderToBeLooked!, 
//               //   proceedText: 'send again',
//               //   onProceedClick: () => _sendOrderAgain(_orderToBeLooked!), 
//               //   onCancel: () => _toggleOrderToBeLooked(null),
//               // ),


              
//               // - - - P A Y M E N T S _ O V E R V I E W
//               if (_showPaymentsOverview) ClipRRect(
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: CSizes.blurSigma, sigmaY: CSizes.blurSigma),
//                   child: GestureDetector(
//                     onTap: _toggleShowPaymentsOverview,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: CColors.dimmedBackgound,
//                         borderRadius: BorderRadius.circular(CSizes.smallRadius + 10)
//                       ),
//                       padding: EdgeInsets.all(CSizes.largeGap),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [                                                
//                           Center(
//                             child: Consumer<PaymentMethodsProvider>(
//                               builder: (context, provider, child) {
//                                 return _paymentsOverviewMethod(
//                                   paymentList: provider.paymentMethods,
//                                   onCancel: _toggleShowPaymentsOverview
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 )
//               ),



//               // - - - S E N D _ O R D E R _ S U C C E S S
//               if (provider.sendOrderSuccessMessage != null) UiPopupWidget(
//                 isSuccess: true,
//                 message: provider.sendOrderSuccessMessage!, 
//                 primaryText: 'ok', 
//                 primaryClick: provider.closeSendOrderAlert, 
//                 outSideClick: provider.closeSendOrderAlert
//               ),



//               // - - - S E N D _ O R D E R _ E R R O R
//               if (provider.sendOrderErrorMessage != null) UiPopupWidget(
//                 message: provider.sendOrderErrorMessage!, 
//                 primaryText: 'try again later', 
//                 primaryClick: provider.closeSendOrderAlert, 
//                 outSideClick: provider.closeSendOrderAlert
//               ),



//               // - - - S E N D _ O R D E R _ L O A D I N G
//               if (provider.sendOrderLoading) UiLoadingScreenWidget(
//                 fullScreen: true,
//                 transparent: true,
//               ),

//             ],
//           );
//         }
//       ),
//     );
//   }





//   // - - - - - - 
//   // - - - M E T H O D S
//   // - - - - - - 





//   Row _toggleBetweenOrderListMethod({ 
//     required bool showOfflineOrders,
//     required int offlineOrdersCount,
//     required DateTime salesDate,
//     required void Function(bool showOffline) onToggleClick,
//     required void Function() onRefreshClick,
//     required void Function() onShowPaymentsOverviewClick,
//     required void Function() onDateClick,
//    }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             // - - - O F F L I N E
//             Stack(
//               alignment: AlignmentGeometry.center,
//               clipBehavior: Clip.none,
//               children: [
//                 UiButtonWidget(
//                   text: "pending orders",
//                   tranparent: !showOfflineOrders,
//                   vericalPadding: CSizes.smallGap,
//                   onClick: () => onToggleClick(true)
//                 ),
//                 if (offlineOrdersCount > 0) Positioned(
//                   top: -10,
//                   right: -5,
//                   child: Container(
//                     width: 25,
//                     height: 25,
//                     decoration: BoxDecoration(
//                       color: CColors.red,
//                       borderRadius: BorderRadius.circular(12.5)
//                     ),
//                     child: Center(
//                       child: Text(
//                         '$offlineOrdersCount'.padLeft(2, '0'),
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: CColors.white
//                         ),
//                       )
//                     ),
//                   ),
//                 )
//               ],
//             ),
        
//             SizedBox(width: CSizes.mediumGap,),
        
//             UiButtonWidget(
//               text: "online sales",
//               tranparent: showOfflineOrders,
//               vericalPadding: CSizes.smallGap,
//               onClick: () => onToggleClick(false),
//             ), 
        
//             SizedBox(width: CSizes.mediumGap,),
        
//             if (!showOfflineOrders) UiButtonWidget(
//               icon: CIcons.refreshIcon,
//               tranparent: true,
//               horizontalPadding: CSizes.smallGap,
//               vericalPadding: CSizes.smallGap,
//               onClick: onRefreshClick,
//             ),

//             SizedBox(width: CSizes.mediumGap,),
        
//             if (!showOfflineOrders) Row(
//               children: [
//                 UiButtonWidget(
//                   icon: CIcons.walletIcon,
//                   tranparent: true,
//                   horizontalPadding: CSizes.smallGap,
//                   vericalPadding: CSizes.smallGap,
//                   onClick: onShowPaymentsOverviewClick,
//                 ),
        
//                 SizedBox(width: CSizes.mediumGap,),
//               ],
//             ),

//             SizedBox(width: CSizes.mediumGap,),
//           ],
//         ),

        
//         // - - - D A T E _ S E L E C T
//         if (!showOfflineOrders)  IntrinsicHeight(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               MouseRegion(
//                 cursor: SystemMouseCursors.click,
//                 child: GestureDetector(
//                   onTap: onDateClick,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: CColors.white,
//                       borderRadius: BorderRadius.circular(CSizes.smallRadius + 10),
//                       border: Border.all(width: 1, color: CColors.whiteShade2)
//                     ),
//                     padding: EdgeInsets.only(right: CSizes.smallGap),
//                     child: Row(
//                       children: [
//                         UiButtonWidget(
//                           icon: CIcons.calendar,
//                           tranparent: true,
//                           horizontalPadding: CSizes.smallGap,
//                           vericalPadding: CSizes.smallGap,
//                           onClick: onDateClick,
//                           borderColor: CColors.transparent,
//                         ),
                  
//                         SizedBox(width: CSizes.smallGap,),
                  
//                         UiTitleWidget(
//                           text: CHelperFunctions.formatDateTime(salesDate),
//                           bold: false,
//                           capitalizeWords: true,
//                           textAlign: TextAlign.end,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
          
//               if (salesDate.day != DateTime.now().day) SizedBox(width: CSizes.smallGap,),
//               if (salesDate.day != DateTime.now().day) UiButtonWidget(
//                 text: 'today',
//                 vericalPadding: 0,
//                 // tranparent: true,
//                 onClick: () => _handleDateChange(DateTime.now())
//               ),
//             ],
//           ),
//         ),

//       ],
//     );
//   }




//    // - - - O R D E R _ H I S T O R Y _ D I S P L A Y _ M E T H O D
//   dynamic _orderHistoryDisplayMethod({ 
//     required List<OrderDataModel> orderDataList, 
//     required bool isOnline,
//     required void Function(OrderDataModel orderData) onShowMoreClickConnect,
//     void Function()? searchAgain,
//   }) {
//       if (orderDataList.isEmpty) {
//         return Center(
//           child: UiNoDataFounded(
//             title: isOnline ? 'no sales are founded' : 'perfect, no pending order list is founded',
//             noDataAnimation: CAnimations.emptyList,
//             buttonText: isOnline ? 'search again' : null,
//             onButtonClick: isOnline ? searchAgain : null,
//           ),
//         );
//       }

//       else {
//         return Container(
//           decoration: BoxDecoration(
//             color: CColors.white,
//             borderRadius: BorderRadius.circular(CSizes.smallRadius + 10)
//           ),
//           clipBehavior: Clip.hardEdge,
//           child: ListView.separated(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) => _orderHistoryTileMethod(
//               index: index, 
//               isOnline: isOnline,
//               orderData: orderDataList[index],
//               onShowMoreClick: (orderData) => onShowMoreClickConnect(orderData),
//             ), 
//             separatorBuilder: (context, index) => Container(height: 1, color: CColors.whiteShade2,), 
//             itemCount: orderDataList.length
//           ),
//         );
//       }
//     // }

//     // // - - - O F F L I N E _ O R D E R _ D A T A
//     // else if (orderDataList != null) {
//     //   if (orderDataList.isEmpty) {
//     //       return Center(
//     //         child: UiNoDataFounded(
//     //           title: 'perfect, no pending order list is founded',
//     //           noDataAnimation: CAnimations.emptyList,
//     //         ),
//     //       );
//     //     }
//     //     else {
//     //       return Container(
//     //         decoration: BoxDecoration(
//     //           color: CColors.white,
//     //           borderRadius: BorderRadius.circular(CSizes.smallRadius + 10)
//     //         ),
//     //         clipBehavior: Clip.hardEdge,
//     //         child: ListView.separated(
//     //           shrinkWrap: true,
//     //           physics: NeverScrollableScrollPhysics(),
//     //           itemBuilder: (context, index) => _orderHistoryTileMethod(
//     //             index: index, 
//     //             orderData: orderDataList[index],
//     //             fullOrderData: null,
//     //             onShowMoreClick: (orderData) => onShowMoreClickConnect(orderData!),
//     //             onShowMoreClick2: (orderData) => {},
//     //           ), 
//     //           separatorBuilder: (context, index) => Container(height: 1, color: CColors.whiteShade2,), 
//     //           itemCount: orderDataList.length
//     //         ),
//     //       );
//     //     }
//     //   }
//     // }
//   }


//   // - - - Order History Tile Method
//   MouseRegion _orderHistoryTileMethod({ 
//     required int index, 
//     required bool isOnline,
//     required OrderDataModel orderData, 
//     required void Function(OrderDataModel orderData) onShowMoreClick,
//   }) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: () => onShowMoreClick(orderData),
//         child: Container(
//           decoration: BoxDecoration(
//             color: CColors.white,
//           ),
//           padding: EdgeInsets.all(CSizes.mediumGap),
//           child: Row(
//             children: [
        
//               Expanded(
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 20,
//                       child: UiTitleWidget(text: (index+1).toString().padLeft(2, '0')),
//                     ),
                
//                     SizedBox(width: CSizes.smallGap,),
                                        
//                     UiTitleWidget(
//                       text: orderData.sellerName,
//                       capitalizeWords: true, bold: false,
//                     )
//                   ],
//                 ),
//               ),
        
//               Expanded(
//                 child: Center(
//                   child: UiTitleWidget(
//                     text: CHelperFunctions.formatDateTime(orderData.createdAt, addTime: true),
//                     color: CColors.whiteShade3,
//                     capitalizeWords: true,
//                     bold: false,
//                   ),
//                 )
//               ),
        
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     UiTitleWidget(
//                       text: '${CHelperFunctions.formatNumberWithComma(orderData.orderCalculation.grandTotal, addDecimal: false)} Birr',
//                       capitalizeWords: true,
//                     ),
        
//                     SizedBox(width: CSizes.mediumGap,),
        
//                     UiButtonWidget(
//                       text: 'see more',
//                       icon: CIcons.eyeOpen,
//                       vericalPadding: CSizes.smallGap,
//                       horizontalPadding: CSizes.mediumGap,
//                       // tranparent: orderData.orderStatus == 'completed',
//                       tranparent: isOnline,
//                       onClick: () => onShowMoreClick(orderData),
//                     ),

//                     // SizedBox(width: CSizes.mediumGap,),

//                     // UiButtonWidget(
//                     //   text: 'print receipt',
//                     //   icon: CIcons.printIcon,
//                     //   vericalPadding: CSizes.smallGap,
//                     //   horizontalPadding: CSizes.mediumGap,
//                     //   onClick: () => onShowMoreClick(orderData),
//                     // ),
//                   ],
//                 ),
//               )
        
//             ],
//           ),
//         ),
//       ),
//     );
//   }





//   // - - - - S A L E S _ O V E R V I E W _ M E T H O D
//   IntrinsicWidth _salesOverViewMethod({
//     required UserModel currentUser,
//     required int totalOrders,
//     required double totalSales,
//     required double totalChange,
//     required double totalCost,
//     required double totalProfit,
//   }) {
//     return IntrinsicWidth(
//       child: IntrinsicHeight(
//         child: SizedBox(
//           height: 100,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
              
//               // Total Orders
//               Expanded(
//                 child: salesOverviewCardMethod(
//                   title: 'total orders',
//                   value: totalOrders.toString().padLeft(2, '0'),
//                   gradient: CColors.gradientGreen
//                 ),
//               ),
          
//               SizedBox(width: CSizes.mediumGap,),
          
//               // Total Sales 
//               Expanded(
//                 child: salesOverviewCardMethod(
//                   title: 'sales',
//                   value: '${CHelperFunctions.formatNumberWithComma(totalSales, addDecimal: true)} Birr',
//                   gradient: CColors.gradientNavyBlue
//                 ),
//               ),
          
//               SizedBox(width: CSizes.mediumGap,),
          
//               // Total Change 
//               Expanded(
//                 child: salesOverviewCardMethod(
//                   title: 'change',
//                   value: '${CHelperFunctions.formatNumberWithComma(totalChange, addDecimal: true)} Birr',
//                   gradient: CColors.gradientOrange
//                 ),
//               ),
          
//               // SizedBox(width: CSizes.largeGap,),
          
//               // if (currentUser.userRole == UserRolesEnum.admin.name) Row(
//               //   children: [
//               //     // Total cost
//               //     salesOverviewCardMethod(
//               //       title: 'cost',
//               //       value: '${CHelperFunctions.formatNumberWithComma(totalCost, addDecimal: true)} Birr',
//               //       gradient: CColors.gradientRed
//               //     ),
              
//               //     SizedBox(width: CSizes.largeGap,),
              
//               //     // Total cost
//               //     salesOverviewCardMethod(
//               //       title: 'profit',
//               //       value: '${CHelperFunctions.formatNumberWithComma(totalProfit, addDecimal: true)} Birr',
//               //       gradient: CColors.gradientGreen
//               //     ),
//               //   ],
//               // )
          
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // - - - S A L E S _ O V E R V I E W _ C A R D _ M E T H O D
//   Container salesOverviewCardMethod({ 
//     required String title, 
//     required String value,
//     Color? color,
//     Gradient? gradient,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: gradient,
//         border: Border.all(width: 1, color: CColors.whiteShade2),
//         borderRadius: BorderRadius.circular(CSizes.smallRadius + 10)
//       ),
//       padding: EdgeInsets.symmetric(vertical: CSizes.largeGap, horizontal: CSizes.xLargeGap),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           UiTitleWidget(
//             text: title,
//             capitalizeWords: true,
//             bigger: true,
//             color: CColors.white,
//           ),

//           SizedBox(width: CSizes.largeGap,),
          
//           UiTitleWidget(
//             text: value,
//             bigger: true,
//             defaultText: true,
//             color: CColors.white,
//           ),
//         ],
//       ),
//     );
//   }






import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mizan_pos/constants/colors.dart';
import 'package:mizan_pos/constants/icons.dart';
import 'package:mizan_pos/constants/sizes.dart';
import 'package:mizan_pos/helpers/helper_functions.dart';
import 'package:mizan_pos/models/order_data_model.dart';
import 'package:mizan_pos/models/payment_method_model.dart';
import 'package:mizan_pos/models/sale_data_model.dart';
import 'package:mizan_pos/models/user_model.dart';
import 'package:mizan_pos/providers/app_info_provider.dart';
import 'package:mizan_pos/providers/payments_provider.dart';
import 'package:mizan_pos/providers/sales_provider.dart';
import 'package:mizan_pos/providers/users_provider.dart';
import 'package:mizan_pos/screens/login_screens/login_screen.dart';
import 'package:mizan_pos/screens/sales_screen/widgets/sale_details_popup_widget.dart';
import 'package:mizan_pos/screens/sales_screen/widgets/sales_list_display_widget.dart';
import 'package:mizan_pos/screens/sales_screen/widgets/sales_overview_widget.dart';
import 'package:mizan_pos/ui/ui_button_widget.dart';
import 'package:mizan_pos/ui/ui_loading_screen_widget.dart';
import 'package:mizan_pos/ui/ui_no_data_founded.dart';
import 'package:mizan_pos/ui/ui_popup_widget.dart';
import 'package:mizan_pos/ui/ui_title_widget.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  late UserModel _userData;
  SaleDataModel? _saleDetails;
  bool? _isOfflineDetails;
  bool _showPaymentsOverview = false;



  // - - - - - -
  // - - - F U N C T I O N S

  // -- -- --
  bool _dateIsToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
      date.month == now.month && 
      date.day == now.day;
  }

  // -- -- --
  void _showDatePicker(DateTime initialDate) {
    showDatePicker(
      context: context, 
      firstDate: DateTime(2026), 
      lastDate: DateTime.now(),
      initialDate: initialDate
    )
    .then(
      (date) {
        if (date == null) return;
        _handleDateChange(date);
      }
    );
  }

  // -- -- --
  Future<void> _handleDateChange(DateTime date) async {
    final SalesProvider salesProvider = Provider.of(context, listen: false);
    await salesProvider.changeSalesDate(date);
  }


  // -- -- --
  void _handleProductDetailsChange(SaleDataModel? data, bool? offline) {
    setState(() { 
      _saleDetails = data;
      _isOfflineDetails = offline;
    });
  }


  // -- -- --
  Future<void> _handleOrderResend(SaleDataModel sale) async {
    final SalesProvider salesProvider = Provider.of(context, listen: false);

    final order = OrderDataModel(
      sellerId: sale.sellerId, cashierId: sale.cashierId, customerId: null, 
      items: sale.items, orderCalculation: sale.orderCalculation, 
      orderPayments: sale.orderPayments, totalChange: sale.totalChange
    );

    await salesProvider.sendOrder(order, resend: true, saleData: sale);
  }


  // -- -- --
  void _toggleShowPaymentOverview() {
    setState(() => _showPaymentsOverview = !_showPaymentsOverview);
  }


  double _calculatePaymentTotal(String paymentId) {
    final SalesProvider salesProvider = Provider.of(context, listen: false);
    final orderList = salesProvider.salesList;
    double total = 0;
    for (var order in orderList) {
      for (var payment in order.orderPayments) { 
        if (payment.paymentId != paymentId) continue; 
        total += payment.paidAmount;
      }
    }
    return total;
  }



  // --- --- ---
  // Future<void> _handleOrderDelete(SaleDataModel sale) async {
  //   final ProductsProvider productsProvider = Provider.of(context, listen: false);
    
  //   final order = OrderDataModel(
  //     sellerId: sale.sellerId, cashierId: sale.cashierId, customerId: null, 
  //     items: sale.items, orderCalculation: sale.orderCalculation, 
  //     orderPayments: sale.orderPayments, totalChange: sale.totalChange
  //   );

  //   await 
  // }


  
  // 
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final AppInfoProvider appInfoProvider = Provider.of(context, listen: false);
    if (appInfoProvider.currentUser == null) {
      await appInfoProvider.userLogout();
      if (!mounted) return;
      CHelperFunctions.navigateToScreen(context: context, screen: LoginScreen(), replacement: true);
    }
    setState(() => _userData = appInfoProvider.currentUser!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          // - - - - - -
          // - - - M A I N _ C O N T A I N E R
          // - - - - - -

          Container(
            padding: EdgeInsets.symmetric(horizontal: CSizes.largeGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: CSizes.largeGap,),
                
                // - - - P A G E _ T I T L E
                UiTitleWidget(text: 'Sales History', bigger: true,),
      
                SizedBox(height: CSizes.largeGap,),
      
                // - - - T O G G L E _ S E C T I O N
                Consumer<SalesProvider>(
                  builder: (context, provider, child) => _toggleBetweenOrderTypesMethod(
                    isOffline: provider.showOfflineOrders,
                    offlineCount: provider.offlineSalesList.length,
                    salesDate: provider.salesDate,
                    onToggleClick: (showOffline) => provider.toggleShowOfflineOrders(showOffline),
                    onRefreshClick: provider.fetchOnlineSales,
                    onShowPaymentsOverviewClick: _toggleShowPaymentOverview,
                    onDateClick: () => _showDatePicker(provider.salesDate),
                  ),
                ),
      
                SizedBox(height: CSizes.largeGap,),
      
      
                // - - - M A I N _ D I S P L A Y
                Expanded(
                  child: Consumer<SalesProvider>(
                    builder: (context, provider, child) {
                      
                      // - - - O F F L I N E
                      if (provider.showOfflineOrders) {
                        // Empty offline orders
                        if (provider.offlineSalesList.isEmpty) return UiNoDataFounded(title: 'offline orders will be displayed here',);

                        // Display offline orders
                        return SingleChildScrollView(
                          child: SalesListDisplayWidget(
                            salesList: provider.offlineSalesList,
                            onSeeDetailsClick: (sale) => _handleProductDetailsChange(sale, true),
                            isOffline: true,
                            onSendAgainClick: (sale) => _handleOrderResend(sale),
                            canDelete: _userData.canEditInventory && _userData.userRole == UserRolesEnum.admin.name,
                            onDeleteClick: (sale) => provider.removeFromOfflineList(sale),
                          ),
                        );  
                      } 
                      


                      
                      // - - - O N L I N E
                      else {
                        // Loading
                        if (provider.isLoading) return UiLoadingScreenWidget(fullScreen: true);

                        // Error
                        if (provider.errorMessage != null) {
                          return UiNoDataFounded(
                            title: provider.errorMessage,
                            buttonText: 'search again',
                            onButtonClick: provider.fetchOnlineSales,
                          );
                        }

                        // Empty online orders
                        if (provider.salesList.isEmpty) {
                          return UiNoDataFounded(
                            title: 'no sales are founded',
                            buttonText: 'search again',
                            onButtonClick: provider.fetchOnlineSales,
                          );
                        }
                        
                        // Display Online orders
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              // Sales Overview
                              SalesOverviewWidget(
                                totalOrders: provider.salesList.length, 
                                totalSales: provider.totalSales, 
                                totalChange: provider.totalChange
                              ),

                              SizedBox(height: CSizes.largeGap,),

                              // Sales List
                              SalesListDisplayWidget(
                                salesList: provider.salesList, 
                                onSeeDetailsClick: (sale) => _handleProductDetailsChange(sale, false)
                              )
                            ],
                          ),
                        );  
                      }

                    },
                  ),
                ),
      
                SizedBox(height: CSizes.largeGap,),
                
              ],
            ),
          ),




          // - - - P A Y M E N T S _ O V E R V I E W
          if (_showPaymentsOverview) ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: CSizes.blurSigma, sigmaY: CSizes.blurSigma),
              child: GestureDetector(
                onTap: _toggleShowPaymentOverview,
                child: Container(
                  decoration: BoxDecoration(
                    color: CColors.dimmedBackgound,
                    borderRadius: BorderRadius.circular(CSizes.smallRadius + 10)
                  ),
                  padding: EdgeInsets.all(CSizes.largeGap),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [                                                
                      Center(
                        child: Consumer<PaymentMethodsProvider>(
                          builder: (context, provider, child) {
                            return _paymentsOverviewMethod(
                              paymentList: provider.paymentMethods,
                              onCancel: _toggleShowPaymentOverview
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            )
          ),




          // - - - - - -
          // - - - S A L E _ D E T A I L S _ P O P U P
          // - - - - - -

          if (_saleDetails != null) Scaffold(
            backgroundColor: CColors.transparent,
            body: SaleDetailsPopupWidget(
              saleData: _saleDetails!,
              isOffline: _isOfflineDetails ?? true,
              onBackClick: () => _handleProductDetailsChange(null, null),
              onSendAgainClick: (sale) {
                _handleProductDetailsChange(null, null);
                _handleOrderResend(sale);
              }
            ),
          ),




          
          // - - - - - -
          // - - - R E S E N D
          // - - - - - -

          Consumer<SalesProvider>(
            builder: (context, provider, child) {
              // Loading
              if (provider.sendIsLoading) { 
                return UiLoadingScreenWidget(
                  fullScreen: true,
                  transparent: true,
                );
              }

              // Success
              if (provider.sendSuccessMessage != null) {
                return UiPopupWidget(
                  isSuccess: true,
                  message: provider.sendSuccessMessage!, 
                  primaryText: 'okay', 
                  primaryClick: provider.clearSendMessage, 
                  outSideClick: provider.clearSendMessage,
                );
              }
              
              // Error
              if (provider.sendErrorMessage != null) {
                return UiPopupWidget(
                  message: provider.sendErrorMessage!, 
                  primaryText: 'try again later', 
                  primaryClick: provider.clearSendMessage, 
                  outSideClick: provider.clearSendMessage,
                );
              }

              return SizedBox();
            },
          )

        ],
      ),
    );
  }





  // - - - - - -
  // - - - M E T H O D S
  // - - - - - -




  // - - - 
  Row _toggleBetweenOrderTypesMethod({
    required bool isOffline,
    required int offlineCount,
    required DateTime salesDate,
    required void Function(bool showOffline) onToggleClick,
    required void Function() onRefreshClick,
    required void Function() onShowPaymentsOverviewClick,
    required void Function() onDateClick,
  }) {
    final bool isToday = _dateIsToday(salesDate);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        Row(
          children: [
            UiButtonWidget(
              text: 'online sales',
              tranparent: isOffline,
              vericalPadding: CSizes.smallGap,
              onClick: () => onToggleClick(false)
            ),

            SizedBox(width: CSizes.mediumGap,),

            Stack(
              alignment: AlignmentGeometry.center,
              clipBehavior: Clip.none,
              children: [
                UiButtonWidget(
                  text: "offline orders",
                  tranparent: !isOffline,
                  vericalPadding: CSizes.smallGap,
                  onClick: () => onToggleClick(true)
                ),
                if (offlineCount > 0) Positioned(
                  top: -10,
                  right: -5,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: CColors.red,
                      borderRadius: BorderRadius.circular(12.5)
                    ),
                    child: Center(
                      child: Text(
                        '$offlineCount'.padLeft(2, '0'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: CColors.white
                        ),
                      )
                    ),
                  ),
                ),


              ],
            ),
            
            SizedBox(width: CSizes.mediumGap,),

            if (!isOffline) UiButtonWidget(
              icon: CIcons.refreshIcon,
              tranparent: true,
              horizontalPadding: CSizes.smallGap,
              vericalPadding: CSizes.smallGap,
              onClick: onRefreshClick,
            ),

            SizedBox(width: CSizes.mediumGap,),

            if (!isOffline) Row(
              children: [
                UiButtonWidget(
                  icon: CIcons.walletIcon,
                  tranparent: true,
                  horizontalPadding: CSizes.smallGap,
                  vericalPadding: CSizes.smallGap,
                  onClick: onShowPaymentsOverviewClick,
                ),
        
                SizedBox(width: CSizes.mediumGap,),
              ],
            ),
          ],
        ),

        SizedBox(width: CSizes.mediumGap,),

        if (!isOffline) Row(
          children: [
            UiButtonWidget(
              icon: CIcons.calendar,
              text: CHelperFunctions.formatDateTime(salesDate),
              tranparent: !isToday,
              vericalPadding: CSizes.smallGap,
              onClick: onDateClick
            ),

            SizedBox(width: CSizes.mediumGap,),

            if (!isToday) UiButtonWidget(
              text: 'today',
              vericalPadding: CSizes.smallGap,
              onClick: () => _handleDateChange(DateTime.now())
            )
          ],
        ),

        
      ],
    );
  }



  // - - - P A Y M E N T S _ O V E R V I E W _ M E T H O D
  GestureDetector _paymentsOverviewMethod({
    required List<PaymentMethodModel> paymentList,
    required void Function() onCancel
  }) {
    return GestureDetector(
      onTap: () {},
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Container(
          decoration: BoxDecoration(
            color: CColors.white,
            borderRadius: BorderRadius.circular(CSizes.smallRadius + 10)
          ),
          padding: EdgeInsets.all(CSizes.largeGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UiTitleWidget(
                text: 'payments overview',
                bigger: true,
                capitalizeWords: true,
                textAlign: TextAlign.center,
              ),
          
              SizedBox(height: CSizes.largeGap,),
      
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) { 
                  final amount = _calculatePaymentTotal(paymentList[index].paymentId);
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: CSizes.largeGap,
                      vertical: CSizes.mediumGap
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UiTitleWidget(
                          text: paymentList[index].paymentName,
                          bold: false,
                        ),
                    
                        SizedBox(width: CSizes.largeGap,),
                        
                        UiTitleWidget(
                          text: '${CHelperFunctions.formatNumberWithComma(amount, addDecimal: amount == 0)} Birr',
                          defaultText: true,
                          color: amount > 0 ? null : CColors.whiteShade2,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Container(height: 1, color: CColors.whiteShade2,),
                itemCount: paymentList.length,
              ),
      
              SizedBox(height: CSizes.largeGap,),
      
              UiButtonWidget(
                text: 'back',
                onClick: onCancel,
              )
      
            ],
          ),
        ),
      ),
    );
  }

}