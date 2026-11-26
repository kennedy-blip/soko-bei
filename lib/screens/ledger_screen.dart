import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/market_models.dart';
import '../storage/app_controller.dart';
import '../widgets/glass_card.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key,required this.controller});
  final AppController controller;
  @override State<LedgerScreen> createState()=>_LedgerScreenState();
}
class _LedgerScreenState extends State<LedgerScreen> {
  String filter='All';
  final money=NumberFormat.currency(locale:'en_KE',symbol:'KSh ',decimalDigits:0);
  Future<void> addEntry() async {
    final commodity=TextEditingController(), amount=TextEditingController(), quantity=TextEditingController(text:'1'), note=TextEditingController();
    String type='Purchase';
    final ok=await showDialog<bool>(context:context,builder:(ctx)=>StatefulBuilder(builder:(ctx,setD)=>AlertDialog(title:const Text('Add ledger entry'),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
      TextField(controller:commodity,decoration:const InputDecoration(labelText:'Commodity')),
      const SizedBox(height:10),DropdownButtonFormField<String>(value:type,decoration:const InputDecoration(labelText:'Entry type'),items:['Purchase','Sale','Spoilage'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setD(()=>type=v!)),
      const SizedBox(height:10),TextField(controller:amount,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Amount (KSh)')),
      const SizedBox(height:10),TextField(controller:quantity,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Quantity')),
      const SizedBox(height:10),TextField(controller:note,decoration:const InputDecoration(labelText:'Note (optional)'))
    ])),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('Save'))])));
    if(ok==true&&commodity.text.trim().isNotEmpty&&(double.tryParse(amount.text)??0)>0) {
      await widget.controller.addLedger(LedgerEntry(id:DateTime.now().microsecondsSinceEpoch.toString(),commodity:commodity.text.trim(),type:type,quantity:double.tryParse(quantity.text)??1,amount:double.parse(amount.text),date:DateTime.now(),note:note.text.trim()));
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Ledger entry saved offline')));
    }
  }
  @override Widget build(BuildContext context) {
    final c=widget.controller;final entries=c.ledger.where((e)=>filter=='All'||e.type==filter).toList();
    return Scaffold(floatingActionButton:FloatingActionButton.extended(onPressed:addEntry,icon:const Icon(Icons.add),label:const Text('Add entry')),
      body:ListView(padding:const EdgeInsets.all(20),children:[
        Text('DAILY PERFORMANCE',style:TextStyle(color:Theme.of(context).colorScheme.primary,fontWeight:FontWeight.w800,letterSpacing:1.5,fontSize:11)),
        const SizedBox(height:7),Text('Margin ledger',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.w800)),
        const SizedBox(height:16),GlassCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('ESTIMATED NET MARGIN',style:TextStyle(color:Theme.of(context).hintColor,fontSize:11,fontWeight:FontWeight.w800,letterSpacing:1.2)),
          const SizedBox(height:5),Text(money.format(c.netMargin),style:TextStyle(fontSize:30,fontWeight:FontWeight.w900,color:c.netMargin>=0?const Color(0xFF35D39A):Colors.orangeAccent)),
          const SizedBox(height:16),Row(children:[_metric('Sales',c.revenue),_metric('Purchases',c.purchases),_metric('Waste',c.waste)])
        ])),
        const SizedBox(height:16),Wrap(spacing:8,children:['All','Purchase','Sale','Spoilage'].map((v)=>ChoiceChip(label:Text(v),selected:filter==v,onSelected:(_)=>setState(()=>filter=v))).toList()),
        const SizedBox(height:12),if(entries.isEmpty) const Padding(padding:EdgeInsets.all(30),child:Center(child:Text('No entries in this view. Add a purchase, sale or spoilage record.'))),
        ...entries.map((e)=>Padding(padding:const EdgeInsets.only(bottom:10),child:GlassCard(child:Row(children:[
          Icon(e.type=='Sale'?Icons.trending_up:e.type=='Spoilage'?Icons.warning_amber_rounded:Icons.shopping_bag_outlined,color:e.type=='Sale'?const Color(0xFF35D39A):e.type=='Spoilage'?Colors.orange:Colors.blueAccent),
          const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(e.commodity,style:const TextStyle(fontWeight:FontWeight.w800)),Text('${e.type} · ${DateFormat('d MMM, HH:mm').format(e.date)}',style:TextStyle(fontSize:11,color:Theme.of(context).hintColor))])),
          Text(money.format(e.amount),style:const TextStyle(fontWeight:FontWeight.w800)),
          if(c.isAdmin) IconButton(tooltip:'Delete entry',onPressed:()=>c.deleteLedger(e.id),icon:const Icon(Icons.delete_outline,size:19))
        ]))))
      ]));
  }
  Widget _metric(String label,double value)=>Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:TextStyle(color:Theme.of(context).hintColor,fontSize:11)),const SizedBox(height:4),Text(money.format(value),style:const TextStyle(fontWeight:FontWeight.w800,fontSize:12))]));
}
