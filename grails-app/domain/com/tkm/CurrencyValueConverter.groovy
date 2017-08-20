package com.tkm

import org.grails.databinding.converters.ValueConverter

class CurrencyValueConverter implements ValueConverter  {
    boolean canConvert(value) {
        value instanceof String
    }
    def convert(value) {
        Currency.getInstance(value)
    }
    Class<?> getTargetType() {
        java.util.Currency
    }
}
