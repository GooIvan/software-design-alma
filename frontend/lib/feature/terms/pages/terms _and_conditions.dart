import 'package:flutter/material.dart';
import 'package:design_alma/utils/extensions.dart'; // IMPORTANTE para context.l10n

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(  
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              l10n.termsTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            Text(
              "${l10n.termsLastUpdated}: ${l10n.termsUpdatedDate}",
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),

            const SizedBox(height: 18),
            Text(
              l10n.termsIntro,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            Text(
              l10n.termsScopeTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.termsScope,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            Text(
              l10n.termsDataTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.termsData,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            Text(
              l10n.termsProductsTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.termsProducts,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            Text(
              l10n.termsPaymentsTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.termsPayments,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            Text(
              l10n.termsDeliveryTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.termsDelivery,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            Text(
              l10n.termsLiabilityTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.termsLiability,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            Text(
              l10n.termsChangesTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.termsChanges,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),
            Text(
              l10n.termsContactTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.termsContact,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 28),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.termsAcceptButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
