import 'package:flutter/material.dart';
import 'dart:io';
import 'package:vision_parse/widgets/email_card.dart';
import 'package:vision_parse/utils/text_extractor.dart';
import 'package:vision_parse/utils/storage_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ExtractPage extends StatefulWidget {
  final String imagePath;
  final String extractedText;
  final bool showSaveButton;
  const ExtractPage({super.key, required this.imagePath, required this.extractedText, this.showSaveButton = true});

  @override
  State<ExtractPage> createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<String> _emails;
  late final List<String> _phones;
  late final List<String> _urls;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _emails = TextExtractor.extractEmails(widget.extractedText);
    _phones = TextExtractor.extractPhones(widget.extractedText);
    _urls = TextExtractor.extractUrls(widget.extractedText);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyzed Image'),
        actions: [
          if (widget.showSaveButton)
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: isSaved ? Colors.green : Colors.black,
            ),
            onPressed: isSaved ? null : () {
              // Aquí puedes implementar la lógica para guardar los datos
              // Por ejemplo, podrías guardar los emails, phones y urls en una base de datos o archivo
              StorageHelper.movePickerFileToHistory(File(widget.imagePath));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Datos guardados exitosamente')),
              );
              setState(() {
                isSaved = true;
              });
            },
            icon: Icon(Icons.save, color: isSaved ? Colors.green : Colors.black),
            label: Text(isSaved ? 'Guardado' : 'Guardar', style: TextStyle(color: isSaved ? Colors.green : Colors.black)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Raw Text'),
            Tab(text: 'Email'),
            Tab(text: 'Phone'),
            Tab(text: 'URLs'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(widget.imagePath),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [

                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(widget.extractedText),
                ),

                _emails.isEmpty
                    ? const Center(child: Text('No emails found.'))
                    : ListView.builder(
                        itemCount: _emails.length,
                        itemBuilder: (context, idx) => EmailCard(email: _emails[idx]),
                      ),

                _phones.isEmpty
                    ? const Center(child: Text('No phone numbers found.'))
                    : ListView.builder(
                        itemCount: _phones.length,
                        itemBuilder: (context, idx) => ListTile(
                          leading: const Icon(Icons.phone),
                          title: Text(_phones[idx]),
                        ),
                      ),

                _urls.isEmpty
                    ? const Center(child: Text('No URLs found.'))
                    : ListView.builder(
                        itemCount: _urls.length,
                        itemBuilder: (context, idx) => ListTile(
                          leading: const Icon(Icons.link),
                          title: Text(_urls[idx]),
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_browser),
                            tooltip: 'Open in browser',
                            onPressed: () async {
                              String urlString = _urls[idx];
                              if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
                                urlString = 'https://'+urlString;
                              }
                              try {
                                final url = Uri.parse(urlString);
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('No se pudo abrir la URL: $urlString')),
                                );
                              }
                              
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}