import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../../shared/widgets/error_display.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil', style: AppTypography.heading2),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.saved) {
            Flushbar(
              message: 'Perfil atualizado com sucesso!',
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.primary,
              margin: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(12),
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
            // Update auth state
            context.read<AuthBloc>().add(const AuthCheckRequested());
          } else if (state.status == ProfileStatus.error) {
            Flushbar(
              message: state.errorMessage ?? 'Erro ao carregar perfil',
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.error,
              margin: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(12),
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const LoadingIndicator(message: 'Carregando perfil...');
          }

          if (state.status == ProfileStatus.error && state.user == null) {
            return ErrorDisplay(
              message: state.errorMessage ?? 'Erro ao carregar perfil',
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            );
          }

          final user = state.user;
          if (user == null) return const LoadingIndicator();

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ProfileHeader(user: user),
              const SizedBox(height: 32),
              ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'Editar nome',
                subtitle: user.name ?? 'Não informado',
                onTap: () => _showEditDialog(
                  context,
                  title: 'Editar nome',
                  initialValue: user.name ?? '',
                  hintText: 'Seu nome',
                  validator: Validators.name,
                  onSave: (value) {
                    context.read<ProfileCubit>().updateProfile(
                          id: user.id,
                          name: value,
                        );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ProfileMenuItem(
                icon: Icons.email_outlined,
                title: 'Editar email',
                subtitle: user.email,
                onTap: () => _showEditDialog(
                  context,
                  title: 'Editar email',
                  initialValue: user.email,
                  hintText: 'Seu email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  onSave: (value) {
                    context.read<ProfileCubit>().updateProfile(
                          id: user.id,
                          email: value,
                        );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ProfileMenuItem(
                icon: Icons.lock_outline,
                title: 'Alterar senha',
                subtitle: '••••••••',
                onTap: () => _showEditDialog(
                  context,
                  title: 'Nova senha',
                  initialValue: '',
                  hintText: 'Mínimo 6 caracteres',
                  obscureText: true,
                  validator: Validators.password,
                  onSave: (value) {
                    context.read<ProfileCubit>().updateProfile(
                          id: user.id,
                          password: value,
                        );
                  },
                ),
              ),
              const SizedBox(height: 28),
              ProfileMenuItem(
                icon: Icons.logout,
                title: 'Sair da conta',
                iconColor: AppColors.warning,
                titleColor: AppColors.warning,
                onTap: () async {
                  final confirmed = await ConfirmationDialog.show(
                    context,
                    title: 'Sair da conta',
                    message: 'Tem certeza que deseja sair?',
                    confirmText: 'Sair',
                    confirmColor: AppColors.warning,
                  );
                  if (confirmed == true && context.mounted) {
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  }
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'MelhorGym v1.0.0',
                  style: AppTypography.bodySmall,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditDialog(
    BuildContext context, {
    required String title,
    required String initialValue,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    required void Function(String) onSave,
  }) {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title, style: AppTypography.heading3),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(hintText: hintText),
              validator: validator,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop();
                  onSave(controller.text.trim());
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    ).then((_) => controller.dispose());
  }
}
