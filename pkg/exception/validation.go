package domain

import "strings"

type ValidationErrors []error

func (ve ValidationErrors) Error() string {
	parts := make([]string, len(ve))
	for i, err := range ve {
		parts[i] = err.Error()
	}
	return strings.Join(parts, "; ")
}

func (ve ValidationErrors) Unwrap() []error {
	return ve
}
