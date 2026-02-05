export type InputType = 'text' | 'email' | 'password' | 'number' | 'tel' | 'url' | 'textarea';
export type InputSize = 'sm' | 'md' | 'lg';

export interface AppInputProps {
  modelValue: string | number;
  label?: string;
  type?: InputType;
  placeholder?: string;
  disabled?: boolean;
  readonly?: boolean;
  required?: boolean;
  error?: string;
  helperText?: string;
  prefixIcon?: string;
  suffixIcon?: string;
  size?: InputSize;
  showPasswordToggle?: boolean;
  containerClass?: string;
}

export interface AppInputEmits {
  'update:modelValue': [value: string | number];
  blur: [event: FocusEvent];
  focus: [event: FocusEvent];
}
