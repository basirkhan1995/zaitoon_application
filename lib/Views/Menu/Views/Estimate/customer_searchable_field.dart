import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaitoon_invoice/Bloc/AccountsCubit/cubit/accounts_cubit.dart';

class AccountSearchableInputField extends StatefulWidget {
  final double? width;
  final TextEditingController? controller;
  final String? hintText;
  final String title;
  final Widget? trailing;
  final Widget? end;
  final bool isRequire;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;

  const AccountSearchableInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.trailing,
    this.end,
    this.isRequire = false,
    this.onChanged,
    this.validator,
    this.width,
    required this.title,
  });

  @override
  State<AccountSearchableInputField> createState() =>
      _AccountSearchableInputFieldState();
}

class _AccountSearchableInputFieldState
    extends State<AccountSearchableInputField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _fieldKey = GlobalKey();
  List<String> _currentSuggestions = []; // Store the current suggestions
  String? _selectedClientName;
  int? _selectedClientId;

  bool isExistTrue = false;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange); // Remove listener
    _focusNode.dispose();
    widget.controller!.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Delay removal of the overlay to allow for item selection
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _showOverlay(BuildContext context) {
    _removeOverlay(); // Ensure only one overlay is displayed at a time

    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (renderBox == null || overlay == null) return;

    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + renderBox.size.height,
        width: renderBox.size.width,
        child: Material(
          elevation: 1,
          child: BlocBuilder<AccountsCubit, AccountsState>(
            builder: (context, state) {
              if (state is AccountsErrorState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.error.toString()),
                );
              }
              if (state is LoadedAccountsState) {
                _currentSuggestions = state.allAccounts
                    .map((e) => e.accountName.toString())
                    .toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.allAccounts.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedClientName =
                              state.allAccounts[index].accountName;
                          _selectedClientId = state.allAccounts[index].accId;
                        });
                        widget.controller?.text =
                            state.allAccounts[index].accountName ??
                                ""; // Assign vendorName to controller
                        widget.onChanged
                            ?.call(state.allAccounts[index].accId.toString());
                        _removeOverlay();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(state.allAccounts[index].accountName ?? ""),
                      ),
                    );
                  },
                );
              }
              return Text(state.toString());
            },
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  String? _customValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!
          .required(AppLocalizations.of(context)!.customer);
    }
    if (!_currentSuggestions.contains(value)) {
      return AppLocalizations.of(context)!.customerNotFound;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 300,
      child: Column(
        spacing: 0,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              widget.isRequire
                  ? Text(
                      " *",
                      style: TextStyle(color: Colors.red.shade900),
                    )
                  : const SizedBox(),
            ],
          ),
          CompositedTransformTarget(
            link: _layerLink,
            child: TextFormField(
              focusNode: _focusNode,
              key: _fieldKey,
              controller: widget.controller,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  // context.read<AccountsCubit>().searchClients(widget.controller!.text);
                  _showOverlay(context);
                } else {
                  // context.read<ItemsSearchBloc>().add(ClearSuggestionsEvent());
                  _removeOverlay();
                }

                // If the value is not in the suggestions, clear the selection
                if (!_currentSuggestions.contains(value)) {
                  setState(() {
                    _selectedClientName = null;
                    _selectedClientId = null;
                  });
                }
              },
              validator:
                  widget.validator ?? _customValidator, // Use custom validator
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                suffixIcon: widget.trailing,
                suffix: widget.end,
                suffixIconConstraints: BoxConstraints(),
                hintText: widget.hintText,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1.5,
                        color: Theme.of(context).colorScheme.primary)),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: Colors.grey)),
              ),
            ),
          ),
          if (_selectedClientName != null &&
              _currentSuggestions.isNotEmpty) // Display the selected item name
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                "$_selectedClientName",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
