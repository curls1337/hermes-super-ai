import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_super_ai/core/app_state.dart';
import 'package:hermes_super_ai/main.dart';

void main() {
  group('HermesAppState RBAC & State Tests', () {
    test('Initial state is authenticated with default superadmin role', () {
      final state = HermesAppState();
      expect(state.isAuthenticated, isTrue);
      expect(state.activeRoleSlug, 'superadmin');
      expect(state.currentRole.canSwitchAgents, isTrue);
    });

    test('Consumer role cannot switch to specialist agents', () {
      final state = HermesAppState();
      state.loginWithRole('consumer');

      expect(state.isAuthenticated, isTrue);
      expect(state.activeRoleSlug, 'consumer');
      expect(state.activeAgentId, 'general');
      expect(state.currentRole.canSwitchAgents, isFalse);

      state.selectAgent('tech_architect');
      expect(state.activeAgentId, 'general');
    });

    test('Guest role cannot delete vault items', () {
      final state = HermesAppState();
      state.loginWithRole('guest');

      final initialCount = state.vaultItems.length;
      expect(state.currentRole.canDeleteVault, isFalse);

      state.deleteVaultItem(state.vaultItems.first.id);
      expect(state.vaultItems.length, initialCount);
    });

    test('Superadmin can switch agents and delete vault items', () {
      final state = HermesAppState();
      state.loginWithRole('superadmin');

      expect(state.currentRole.canSwitchAgents, isTrue);
      expect(state.currentRole.canDeleteVault, isTrue);

      state.selectAgent('creative_director');
      expect(state.activeAgentId, 'creative_director');

      final firstId = state.vaultItems.first.id;
      final beforeCount = state.vaultItems.length;
      state.deleteVaultItem(firstId);
      expect(state.vaultItems.length, beforeCount - 1);
    });

    test('Vault filter and storyboard beat addition update state', () {
      final state = HermesAppState();
      state.setVaultFilter('video');
      expect(state.vaultFilter, 'video');

      final initialBeats = state.beats.length;
      state.addStoryboardBeat('Closing CTA', 'Fola (Narrator)', 'Unduh sekarang.');
      expect(state.beats.length, initialBeats + 1);
    });
  });

  group('HermesSuperAiApp Widget Tests', () {
    testWidgets('Shows LoginScreen first and navigates to 5-tab Glass Dock',
        (WidgetTester tester) async {
      final state = HermesAppState();
      await tester.pumpWidget(HermesSuperAiApp(appState: state));

      expect(find.text('HERMES SUPER AI'), findsOneWidget);
      expect(find.text('QUICK DEMO ROLE LAUNCHER (1-KLIK)'), findsOneWidget);

      await tester.tap(find.text('⚡ PRO CREATOR'));
      await tester.pumpAndSettle();

      expect(state.isAuthenticated, isTrue);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Studio'), findsOneWidget);
      expect(find.text('Video'), findsOneWidget);
      expect(find.text('Voice'), findsOneWidget);
      expect(find.text('Vault'), findsOneWidget);

      await tester.tap(find.text('Video'));
      await tester.pumpAndSettle();
      expect(find.text('AI Video Lab'), findsOneWidget);
    });
  });
}
