package com.tkm

class SearchContext implements Serializable {
    List<SearchableField> fields = []
    int max = Integer.MAX_VALUE
    int offset = 0
    String sort = null
    String order = 'asc'
    int total = 0
    List results = []
}
