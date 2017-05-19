package com.hibernate.dialect;

import java.sql.Types;
import org.hibernate.dialect.Oracle10gDialect;

public class Oracle11gDialect extends Oracle10gDialect {

    protected void registerCharacterTypeMappings() {
        super.registerCharacterTypeMappings();
        registerColumnType(Types.VARCHAR, "clob");
    }

    protected void registerLargeObjectTypeMappings() {
        super.registerLargeObjectTypeMappings();
        registerColumnType(Types.LONGVARCHAR, "clob");
    }
}
