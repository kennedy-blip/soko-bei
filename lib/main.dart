import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'storage/app_controller.dart';
import 'storage/local_store.dart';
import 'theme/app_theme.dart';
import 'screens/prices_screen.dart';
import 'screens/ledger_screen.dart';
import 'screens/watchlist_screen.dart';
import 'screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) GoogleFonts.config.allowRuntimeFetching = false;
  final controller=AppController(LocalStore());
  await controller.load();
  runApp(SokoBeiApp(controller:controller));
}
class SokoBeiApp extends StatelessWidget {
  const SokoBeiApp({super.key,required this.controller});
  final AppController controller;
  @override Widget build(BuildContext context) => AnimatedBuilder(animation:controller,builder:(context,_) =>
    MaterialApp(title:'SokoBei',debugShowCheckedModeBanner:false,theme:AppTheme.build(controller.themeName),
      home:HomeShell(controller:controller)));
}
class HomeShell extends StatefulWidget {
  const HomeShell({super.key,required this.controller});
  final AppController controller;
  @override State<HomeShell> createState()=>_HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int index=0;
  @override Widget build(BuildContext context) {
    final c=widget.controller;
    final pages=<Widget>[PricesScreen(controller:c),LedgerScreen(controller:c),WatchlistScreen(controller:c),SettingsScreen(controller:c)];
    return Scaffold(
      appBar:AppBar(title:Row(children:[
        Container(width:34,height:34,decoration:BoxDecoration(color:AppTheme.emerald.withValues(alpha:.16),borderRadius:BorderRadius.circular(11)),child:const Icon(Icons.storefront_rounded,color:AppTheme.emerald,size:20)),
        const SizedBox(width:10),const Text('SokoBei',style:TextStyle(fontWeight:FontWeight.w900,letterSpacing:-.5)),
        const Spacer(),Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),decoration:BoxDecoration(color:AppTheme.emerald.withValues(alpha:.12),borderRadius:BorderRadius.circular(20)),child:const Row(children:[Icon(Icons.cloud_off_rounded,size:13,color:AppTheme.emerald),SizedBox(width:5),Text('OFFLINE READY',style:TextStyle(fontSize:9,fontWeight:FontWeight.w900,color:AppTheme.emerald,letterSpacing:.6))]))
      ])),
      body:Stack(children:[
        Positioned(top:-150,right:-120,child:Container(width:340,height:340,decoration:BoxDecoration(shape:BoxShape.circle,color:AppTheme.emerald.withValues(alpha:.07)))),
        Positioned(bottom:-180,left:-130,child:Container(width:360,height:360,decoration:BoxDecoration(shape:BoxShape.circle,color:AppTheme.amber.withValues(alpha:.05)))),
        SafeArea(top:false,child:AnimatedSwitcher(duration:const Duration(milliseconds:260),child:KeyedSubtree(key:ValueKey(index),child:pages[index])))
      ]),
      bottomNavigationBar:NavigationBar(selectedIndex:index,onDestinationSelected:(v)=>setState(()=>index=v),destinations:const [
        NavigationDestination(icon:Icon(Icons.price_change_outlined),selectedIcon:Icon(Icons.price_change),label:'Prices'),
        NavigationDestination(icon:Icon(Icons.receipt_long_outlined),selectedIcon:Icon(Icons.receipt_long),label:'Margin Ledger'),
        NavigationDestination(icon:Icon(Icons.notifications_active_outlined),selectedIcon:Icon(Icons.notifications_active),label:'Watchlist'),
        NavigationDestination(icon:Icon(Icons.tune_outlined),selectedIcon:Icon(Icons.tune),label:'Settings')
      ]),
    );
  }
}
