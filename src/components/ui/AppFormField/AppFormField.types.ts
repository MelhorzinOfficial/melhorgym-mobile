export type FieldSpan = 1 | 2 | 3 | 'full';

export interface AppFormFieldProps {
  span?: FieldSpan;
  containerClass?: string;
}
