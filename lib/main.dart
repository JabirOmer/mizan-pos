import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mizan_pos/app.dart';
import 'package:mizan_pos/constants/colors.dart';
import 'package:mizan_pos/constants/hive_strings.dart';
import 'package:mizan_pos/models/order_calculation_model.dart';
import 'package:mizan_pos/models/order_data_model.dart';
import 'package:mizan_pos/models/order_item_model.dart';
import 'package:mizan_pos/models/order_payment_model.dart';
import 'package:mizan_pos/models/order_session_model.dart';
import 'package:mizan_pos/models/payment_method_model.dart';
import 'package:mizan_pos/models/product_category_model.dart';
import 'package:mizan_pos/models/product_model.dart';
import 'package:mizan_pos/models/sale_data_model.dart';
import 'package:mizan_pos/models/user_model.dart';
import 'package:mizan_pos/providers/app_info_provider.dart';
import 'package:mizan_pos/providers/app_routes_provider.dart';
import 'package:mizan_pos/providers/payments_provider.dart';
import 'package:mizan_pos/providers/products_provider.dart';
import 'package:mizan_pos/providers/sales_provider.dart';
import 'package:mizan_pos/providers/users_provider.dart';
import 'package:mizan_pos/providers/web_socket_server_provider.dart';
import 'package:mizan_pos/services/secure_store_services.dart';
import 'package:mizan_pos/services/shared_preferences_services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // - - - I N I T I A L I Z E _ H I V E
  await Hive.initFlutter();

  // - - - I N I T I A L I Z E _ S H A R E D _ P R E F E R E N C E S
  await CSharedPreferencesServices.init();

  // // - - - F R E S H _ S T A R T
  // await _clearAllLocalData();

  // - - - R E G I S T E R _ H I V E _ A D A P T E R S
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(ProductCategoryModelAdapter());
  Hive.registerAdapter(PaymentMethodModelAdapter());
  Hive.registerAdapter(OrderDataModelAdapter());
  Hive.registerAdapter(OrderItemModelAdapter());
  Hive.registerAdapter(OrderCalculationModelAdapter());
  Hive.registerAdapter(OrderPaymentModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(OrderSessionModelAdapter());
  Hive.registerAdapter(SaleDataModelAdapter());


  // - - - O P E N _ H I V E _ B O X E S
  await Hive.openBox<ProductModel>(CHiveStrings.productsBox);
  await Hive.openBox<ProductCategoryModel>(CHiveStrings.productCategoriesBox);
  final sessions = await Hive.openBox<OrderSessionModel>(CHiveStrings.orderSessionsBox);
  await Hive.openBox<PaymentMethodModel>(CHiveStrings.paymentMethodsBox);
  await Hive.openBox<UserModel>(CHiveStrings.usersBox);
  await Hive.openBox<SaleDataModel>(CHiveStrings.offlineSalesBox);

  print('Sessions: ${sessions.values.length}');


  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky, // hides status & nav bars
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: CColors.primaryColor,
      statusBarIconBrightness: Brightness.light
    )
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => AppInfoProvider()),

        ChangeNotifierProvider(create: (context) => WebSocketServerProvider()),

        ChangeNotifierProvider(create: (_) => AppRoutesProvider()),
        ChangeNotifierProvider(create: (_) => PaymentMethodsProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),

        ChangeNotifierProvider(create: (context) => ProductsProvider(
          webSocketServerProvider: context.read<WebSocketServerProvider>()
        )),

        ChangeNotifierProvider( create: (context) => AppInfoProvider(
          productsProvider: context.read<ProductsProvider>()
        )),

        ChangeNotifierProvider(create: (context) => SalesProvider(
          appInfoProvider: context.read<AppInfoProvider>()
        )),
      ],
      child: App(),
    )
  );

  // runApp(MaterialApp(
  //   home: Scaffold(),
  // ));
}


Future<void> _clearAllLocalData() async {
  final hiveBoxNameList = [
    CHiveStrings.productsBox,
    CHiveStrings.productCategoriesBox,
    CHiveStrings.paymentMethodsBox,
    CHiveStrings.offlineSalesBox,
    CHiveStrings.usersBox,
  ];
  for (var boxName in hiveBoxNameList) { await Hive.deleteBoxFromDisk(boxName); }

  await CSecureStorageService().deleteAll();
  await CSharedPreferencesServices().clear();
}