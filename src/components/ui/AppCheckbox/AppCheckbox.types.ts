export type CheckboxSize = 'sm' | 'md' | 'lg';

export interface AppCheckboxProps {
  modelValue: boolean;
  label?: string;
  disabled?: boolean;
  required?: boolean;
  error?: string;
  helperText?: string;
  size?: CheckboxSize;
  containerClass?: string;
}

export interface AppCheckboxEmits {
  'update:modelValue': [value: boolean];
  change: [value: boolean];
}
