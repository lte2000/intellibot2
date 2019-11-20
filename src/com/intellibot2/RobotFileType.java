package com.intellibot2;

import com.intellij.openapi.fileTypes.LanguageFileType;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;

public class RobotFileType extends LanguageFileType {
    public static final RobotFileType INSTANCE = new RobotFileType();

    private RobotFileType() {
        super(RobotLanguage.INSTANCE);
    }

    @NotNull
    @Override
    public String getName() {
        return "Robot file";
    }

    @NotNull
    @Override
    public String getDescription() {
        return "Robot language file";
    }

    @NotNull
    @Override
    public String getDefaultExtension() {
        return "robot";
    }

    @Nullable
    @Override
    public Icon getIcon() {
        return RobotIcons.FILE;
    }
}
