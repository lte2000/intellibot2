package com.intellibot2;

import com.intellij.lexer.FlexAdapter;

import java.io.Reader;

public class RobotLexerAdapter extends FlexAdapter {
    public RobotLexerAdapter() {
        super(new RobotLexer((Reader) null));
    }
}
