import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailCard extends StatelessWidget {
  final String email;

  const EmailCard({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.email),
      title: Text(email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copiar',
            onPressed: () {
              // Copy email to clipboard
              Clipboard.setData(ClipboardData(text: email));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email copiado al portapapeles')),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Más opciones',
            onSelected: (value) async {
              if (value == 'share') {
                // use share api
                SharePlus.instance.share(
                  ShareParams(
                    text: email,
                    subject: 'Your Subject Here',
                  ),
                );
              } else if (value == 'send_email') {
                // use email api
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: email,
                  query: 'subject=Your Subject Here',
                );
                await launchUrl(emailLaunchUri);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Text('Compartir'),
              ),
              const PopupMenuItem(
                value: 'send_email',
                child: Text('Enviar Email'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}