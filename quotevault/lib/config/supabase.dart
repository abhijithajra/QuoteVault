import 'package:supabase_flutter/supabase_flutter.dart';

const url = "https://mfojysbzksawzkiykxds.supabase.co";
const anonKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1mb2p5c2J6a3Nhd3praXlreGRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzMDU2MDEsImV4cCI6MjA4Mzg4MTYwMX0.btNqmbk7BclNDyNtg3HCHF2ZSaRf13qcDWI3o9Kp3GE";

Future<void> initSupabase() async {
  await Supabase.initialize(url: url, anonKey: anonKey);
}

final supabase = Supabase.instance.client;
