
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '1ap_math_curriculum.dart';

class NibrasLessonPdfService {
  static Future<void> printLesson({
    required BuildContext context,
    required NibrasLessonContent lesson,
    required String languageCode,
  }) async {
    final language =
        languageCode.toLowerCase().startsWith('en') ? 'en' : 'fr';

    final title = lesson.title(language);
    final document = pw.Document(
      title: 'Nibras Academy - $title',
      author: 'Nibras Academy',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(42),
        build: (pdfContext) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#102D69'),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'NIBRAS ACADEMY',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 23,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  language == 'en'
                      ? 'Grade 1 - Mathematics | Revision sheet'
                      : '1ère année primaire - Mathématiques | Fiche de révision',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 22),
          _section(
            language == 'en' ? 'LEARNING OBJECTIVE' : 'OBJECTIF',
            lesson.objective(language),
          ),
          _section(
            language == 'en'
                ? 'LESSON - KEY IDEAS'
                : 'LE COURS - L’ESSENTIEL',
            lesson.course(language),
          ),
          _section(
            language == 'en' ? 'GUIDED EXAMPLE' : 'EXEMPLE GUIDÉ',
            lesson.example(language),
          ),
          pw.SizedBox(height: 14),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#EAF1FF'),
              border: pw.Border.all(
                color: PdfColor.fromHex('#3157C8'),
                width: 1.3,
              ),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  language == 'en'
                      ? 'REMEMBER BY HEART'
                      : 'À RETENIR PAR CŒUR',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#102D69'),
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  lesson.remember(language),
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                    lineSpacing: 5,
                  ),
                ),
              ],
            ),
          ),
          pw.Spacer(),
          pw.Divider(color: PdfColors.grey400),
          pw.Text(
            language == 'en'
                ? 'Nibras Academy - Learning, practice and progress.'
                : 'Nibras Academy - Apprendre, s’entraîner et progresser.',
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );

    try {
      await Printing.layoutPdf(
        onLayout: (_) async => document.save(),
        name: 'nibras_' + lesson.id + '_' + language + '.pdf',
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            language == 'en'
                ? 'Could not open PDF preview: $error'
                : 'Impossible d’ouvrir l’aperçu PDF : $error',
          ),
        ),
      );
    }
  }

  static pw.Widget _section(String title, String body) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#102D69'),
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            body,
            style: const pw.TextStyle(
              fontSize: 11,
              lineSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }
}
