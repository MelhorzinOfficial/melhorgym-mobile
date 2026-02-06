import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../cubits/register_cubit.dart';
import '../cubits/register_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().register(
            name: _nameController.text.trim().isEmpty
                ? null
                : _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.success) {
            Flushbar(
              message: 'Conta criada com sucesso! Faça login.',
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.primary,
              margin: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(12),
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
            final nav = GoRouter.of(context);
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) nav.pop();
            });
          } else if (state.status == RegisterStatus.failure) {
            Flushbar(
              message: state.errorMessage ?? 'Erro ao criar conta',
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.error,
              margin: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(12),
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Criar conta',
                      style: AppTypography.heading1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preencha os dados para se cadastrar',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AuthTextField(
                      controller: _nameController,
                      hintText: 'Seu nome (opcional)',
                      labelText: 'Nome',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _emailController,
                      hintText: 'seu@email.com',
                      labelText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      hintText: 'Mínimo 6 caracteres',
                      labelText: 'Senha',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      validator: Validators.password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textTertiary,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirme sua senha',
                      labelText: 'Confirmar senha',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textTertiary,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return AuthButton(
                          text: 'Criar conta',
                          isLoading: state.status == RegisterStatus.loading,
                          onPressed: _onRegister,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Já tem uma conta? ',
                          style: AppTypography.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Faça login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
