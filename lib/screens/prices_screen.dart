import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/market_models.dart';
import '../storage/app_controller.dart';
import '../widgets/glass_card.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key,required this.controller});
  final AppController controller;
  @override State<PricesScreen> createState()=>_PricesScreenState();
}
class _PricesScreenState extends State<PricesScreen> {
  final search=TextEditingController();
  final money=NumberFormat.currency(locale:'en_KE',symbol:'KSh ',decimalDigits:0);
  Future<void> addPrice() async {
    final c=widget.controller;
    final commodity=TextEditingController(), market=TextEditingController(text:'Local market');
    final price=TextEditingController(), qty=TextEditingController(text:'1');
    String unit='kg', category='Produce';
    final ok=await showDialog<bool>(context:context,builder:(ctx)=>StatefulBuilder(builder:(ctx,setD)=>AlertDialog(
      title:const Text('Record market price'),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
        TextField(controller:commodity,decoration:const InputDecoration(labelText:'Commodity (e.g. Tomatoes)')),
        const SizedBox(height:10),TextField(controller:market,decoration:const InputDecoration(labelText:'Market / location')),
        const SizedBox(height:10),TextField(controller:price,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Total price (KSh)')),
        const SizedBox(height:10),TextField(controller:qty,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Quantity represented')),
        const SizedBox(height:10),DropdownButtonFormField<String>(value:unit,decoration:const InputDecoration(labelText:'Unit'),items:['kg','bag','crate','gorogoro','tin','piece'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setD(()=>unit=v!)),
        const SizedBox(height:10),DropdownButtonFormField<String>(value:category,decoration:const InputDecoration(labelText:'Category'),items:['Produce','Perishable','Dry goods','Other'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setD(()=>category=v!)),
      ])),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('Save price'))])));
    if(ok==true && commodity.text.trim().isNotEmpty && (double.tryParse(price.text)??0)>0 && (double.tryParse(qty.text)??0)>0) {
      await c.addPrice(PriceObservation(id:DateTime.now().microsecondsSinceEpoch.toString(),commodity:commodity.text.trim(),market:market.text.trim(),unit:unit,quantity:double.parse(qty.text),price:double.parse(price.text),date:DateTime.now(),category:category));
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Price saved on this device')));
    }
  }
  @override Widget build(BuildContext context) {
    final items=widget.controller.prices.where((p)=>p.commodity.toLowerCase().contains(search.text.toLowerCase())||p.market.toLowerCase().contains(search.text.toLowerCase())).toList();
    return Scaffold(body:CustomScrollView(slivers:[
      SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.fromLTRB(20,20,20,12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('MARKET INTELLIGENCE',style:TextStyle(color:Theme.of(context).colorScheme.primary,fontWeight:FontWeight.w800,letterSpacing:1.5,fontSize:11)),
        const SizedBox(height:7),Text('Prices that make sense.',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.w800)),
        const SizedBox(height:6),Text('Compare local units. Know your true cost before you buy.',style:Theme.of(context).textTheme.bodyMedium?.copyWith(color:Theme.of(context).hintColor)),
        const SizedBox(height:18),GlassCard(child:Row(children:[const Icon(Icons.insights,color:Color(0xFF35D39A),size:30),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Your benchmark book',style:TextStyle(fontWeight:FontWeight.w800)),Text('${widget.controller.prices.length} observations saved offline',style:TextStyle(color:Theme.of(context).hintColor,fontSize:12))])),TextButton.icon(onPressed:addPrice,icon:const Icon(Icons.add),label:const Text('Add price'))])),
        const SizedBox(height:16),TextField(controller:search,onChanged:(_)=>setState(()=>{}),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search commodity or market')),
        const SizedBox(height:14)]))),
      if(items.isEmpty) SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.all(26),child:Center(child:Column(children:[Icon(Icons.storefront_outlined,size:48,color:Theme.of(context).hintColor),const SizedBox(height:12),const Text('No price observations yet'),const Text('Add your first market quote to start benchmarking.')]))))
      else SliverList(delegate:SliverChildBuilderDelegate((ctx,i){final p=items[i];return Padding(padding:const EdgeInsets.fromLTRB(20,0,20,12),child:GlassCard(child:Row(children:[
        Container(width:44,height:44,decoration:BoxDecoration(color:const Color(0xFF35D39A).withValues(alpha:.13),borderRadius:BorderRadius.circular(14)),child:const Icon(Icons.eco_outlined,color:Color(0xFF35D39A))),
        const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(p.commodity,style:const TextStyle(fontWeight:FontWeight.w800,fontSize:16)),Text('${p.market} · ${DateFormat('d MMM').format(p.date)}',style:TextStyle(color:Theme.of(context).hintColor,fontSize:12)),Text('${money.format(p.unitCost)} / ${p.unit}',style:const TextStyle(color:Color(0xFF35D39A),fontWeight:FontWeight.w700))])),
        Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text(money.format(p.price),style:const TextStyle(fontWeight:FontWeight.w800)),Text('${p.quantity.toStringAsFixed(1)} ${p.unit}',style:TextStyle(color:Theme.of(context).hintColor,fontSize:11))])
      ])));},childCount:items.length))
    ]));
  }
}
