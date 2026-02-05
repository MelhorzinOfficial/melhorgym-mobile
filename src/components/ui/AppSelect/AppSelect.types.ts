export type SelectSize = 'sm' | 'md' | 'lg';

export interface SelectOption {
  label: string;
  value: string | number;
  disabled?: boolean;
}

export interface AppSelectProps {
  modelValue: string | number;
  options: SelectOption[];
  label?: string;
  placeholder?: string;
  disabled?: boolean;
  required?: boolean;
  error?: string;
  helperText?: string;
  size?: SelectSize;
  containerClass?: string;
}

export interface AppSelectEmits {
  'update:modelValue': [value: string | number];
  blur: [event: FocusEvent];
  focus: [event: FocusEvent];
  change: [value: string | number];
}
