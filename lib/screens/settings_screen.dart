import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../storage/app_controller.dart';
import '../storage/local_store.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key,required this.controller});
  final AppController controller;
  @override State<SettingsScreen> createState()=>_SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen> {
  int bytes=0;
  @override void initState(){super.initState();_refresh();}
  Future<void> _refresh() async {final n=await LocalStore().bytesUsed();if(mounted)setState(()=>bytes=n);}
  @override Widget build(BuildContext context) {
    final c=widget.controller;
    return Scaffold(body:ListView(padding:const EdgeInsets.all(20),children:[
      Text('WORKSPACE',style:TextStyle(color:Theme.of(context).colorScheme.primary,fontWeight:FontWeight.w800,letterSpacing:1.5,fontSize:11)),
      const SizedBox(height:7),Text('Settings & access',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.w800)),
      const SizedBox(height:18),GlassCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('Appearance',style:TextStyle(fontWeight:FontWeight.w800,fontSize:16)),const SizedBox(height:12),
        DropdownButtonFormField<String>(value:c.themeName,decoration:const InputDecoration(labelText:'Theme mode'),items:['Market Obsidian','Daylight Stall','High-Contrast Sun'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v){if(v!=null)c.setTheme(v);})
      ])),
      const SizedBox(height:12),GlassCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('User privileges',style:TextStyle(fontWeight:FontWeight.w800,fontSize:16)),const SizedBox(height:5),Text('Choose the active workspace role.',style:TextStyle(color:Theme.of(context).hintColor,fontSize:12)),const SizedBox(height:12),
        DropdownButtonFormField<String>(value:c.role,decoration:const InputDecoration(labelText:'Active role'),items:['Market Lead','Buyer / Stall Clerk'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v){if(v!=null)c.setRole(v);}),
        const SizedBox(height:10),Text(c.isAdmin?'Admin access: ledger deletion enabled.':'Clerk access: record prices and ledger activity. Historical deletion is disabled.',style:TextStyle(color:Theme.of(context).hintColor,fontSize:12))
      ])),
      const SizedBox(height:12),GlassCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('Local storage',style:TextStyle(fontWeight:FontWeight.w800,fontSize:16)),const SizedBox(height:8),
        const Row(children:[Icon(Icons.offline_pin_outlined,color:Color(0xFF35D39A)),SizedBox(width:8),Text('Offline records stored on this device')]),
        Text('${(bytes/1024).toStringAsFixed(1)} KB · SharedPreferences',style:TextStyle(color:Theme.of(context).hintColor,fontSize:12)),
        Align(alignment:Alignment.centerRight,child:TextButton(onPressed:_refresh,child:const Text('Refresh status')))
      ])),
      const SizedBox(height:12),GlassCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('Android app',style:TextStyle(fontWeight:FontWeight.w800,fontSize:16)),const SizedBox(height:6),Text('Install the latest SokoBei Android release for a native, offline-ready experience.',style:TextStyle(color:Theme.of(context).hintColor,fontSize:12)),const SizedBox(height:12),
        SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:()=>_download(context),icon:const Icon(Icons.android),label:const Text('Download Android APK')))
      ])),
      const SizedBox(height:18),Center(child:Text('SokoBei · Built for the rhythm of the market',style:TextStyle(color:Theme.of(context).hintColor,fontSize:11)))
    ]));
  }
  Future<void> _download(BuildContext context) async {
    final uri=Uri.parse('https://github.com/kennedy-blip/soko-bei/releases/latest/download/soko-bei.apk');
    try {
      final opened=await launchUrl(uri,mode:LaunchMode.externalApplication);
      if(!opened && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('APK release not published yet. Visit GitHub Releases after the build workflow runs.')));
    } catch (_) {
      if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Could not open the APK link. Visit the SokoBei GitHub Releases page.')));
    }
  }
}
