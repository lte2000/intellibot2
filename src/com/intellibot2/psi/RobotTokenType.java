package com.intellibot2.psi;

import com.intellibot2.RobotLanguage;
import com.intellij.psi.tree.IElementType;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;

public class RobotTokenType extends IElementType {
    public RobotTokenType(@NotNull @NonNls String debugName) {
        super(debugName, RobotLanguage.INSTANCE);
    }

    @Override
    public String toString() {
        return "RobotTokenType." + super.toString();
    }
}
