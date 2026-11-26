import 'package:flutter/material.dart';
import '../storage/app_controller.dart';
import '../widgets/glass_card.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key,required this.controller});
  final AppController controller;
  @override Widget build(BuildContext context) {
    final list=controller.watchlist;
    return Scaffold(body:ListView(padding:const EdgeInsets.all(20),children:[
      Text('BUYER ALERTS',style:TextStyle(color:Theme.of(context).colorScheme.primary,fontWeight:FontWeight.w800,letterSpacing:1.5,fontSize:11)),
      const SizedBox(height:7),Text('Watch before you buy.',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.w800)),
      const SizedBox(height:6),Text('A simple local watchlist based on recorded price changes and perishability tags.',style:TextStyle(color:Theme.of(context).hintColor)),
      const SizedBox(height:18),GlassCard(child:Row(children:[const Icon(Icons.notifications_active_outlined,color:Colors.orangeAccent,size:28),const SizedBox(width:12),Expanded(child:Text('${list.length} watchlist signals from your saved observations',style:const TextStyle(fontWeight:FontWeight.w700)))])),
      const SizedBox(height:14),if(list.isEmpty) const Padding(padding:EdgeInsets.all(28),child:Center(child:Text('No watchlist signals yet. Tag observations as Perishable or record a higher quote for the same commodity.'))),
      ...list.map((p)=>Padding(padding:const EdgeInsets.only(bottom:10),child:GlassCard(child:Row(children:[
        const Icon(Icons.warning_amber_rounded,color:Colors.orangeAccent,size:26),const SizedBox(width:12),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(p.commodity,style:const TextStyle(fontWeight:FontWeight.w800)),Text(p.category=='Perishable'?'Perishability risk':'Price is at least 15% above another saved quote',style:TextStyle(color:Theme.of(context).hintColor,fontSize:12)),Text('${p.market} · ${p.unitCost.toStringAsFixed(1)} per ${p.unit}',style:const TextStyle(color:Colors.orangeAccent,fontWeight:FontWeight.w700,fontSize:12))]))
      ]))))
    ]));
  }
}
