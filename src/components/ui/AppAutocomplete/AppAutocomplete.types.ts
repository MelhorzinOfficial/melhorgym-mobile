export type AutocompleteSize = 'sm' | 'md' | 'lg';

export interface AutocompleteOption {
  label: string;
  value: string;
  group?: string;
}

export interface AppAutocompleteProps {
  modelValue: string;
  options: AutocompleteOption[];
  label?: string;
  placeholder?: string;
  disabled?: boolean;
  required?: boolean;
  error?: string;
  helperText?: string;
  size?: AutocompleteSize;
  allowCustomValue?: boolean;
  containerClass?: string;
}

export interface AppAutocompleteEmits {
  'update:modelValue': [value: string];
  blur: [event: FocusEvent];
  focus: [event: FocusEvent];
  change: [value: string];
}
