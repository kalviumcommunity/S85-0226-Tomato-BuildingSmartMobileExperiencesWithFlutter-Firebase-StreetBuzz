import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onToggleVisibility;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autofocus;
  final int? maxLines;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.onTap,
    this.onChanged,
    this.onToggleVisibility,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
    this.maxLines = 1,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  late Animation<double> _focusAnimation;
  late Animation<Color?> _labelColorAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _labelColorAnimation = ColorTween(
      begin: Colors.grey[600]!,
      end: Theme.of(context).colorScheme.primary,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isFocused 
                        ? theme.colorScheme.primary.withAlpha(51)
                        : Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: _isFocused ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                autofocus: widget.autofocus,
                maxLines: widget.maxLines,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelStyle: TextStyle(
                    color: _labelColorAnimation.value ?? Colors.grey[600]!,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: widget.prefixIcon,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon != null ||
                          widget.onToggleVisibility != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: widget.suffixIcon ??
                              (widget.obscureText
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey[600],
                                        size: 20,
                                      ),
                                      onPressed: widget.onToggleVisibility,
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.visibility,
                                        color: Colors.grey[600],
                                        size: 20,
                                      ),
                                      onPressed: widget.onToggleVisibility,
                                    )),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: 2,
                    ),
                  ),
                  errorText: null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onTap: () {
                  setState(() => _isFocused = true);
                  _focusController.forward();
                },
                onFieldSubmitted: (_) {
                  setState(() => _isFocused = false);
                  _focusController.reverse();
                },
              ),
            );
          },
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
