package com.intellibot2.psi;

import com.intellibot2.RobotFileType;
import com.intellibot2.RobotLanguage;
import com.intellij.extapi.psi.PsiFileBase;
import com.intellij.openapi.fileTypes.FileType;
import com.intellij.psi.FileViewProvider;
import org.jetbrains.annotations.NotNull;

import javax.swing.*;

public class RobotFile extends PsiFileBase {

    public RobotFile(@NotNull FileViewProvider viewProvider) {
        super(viewProvider, RobotLanguage.INSTANCE);
    }

    @NotNull
    @Override
    public FileType getFileType() {
        return RobotFileType.INSTANCE;
    }

    @Override
    public String toString() {
        return "Robot File";
    }

    @Override
    public Icon getIcon(int flags) {
        return super.getIcon(flags);
    }
}
