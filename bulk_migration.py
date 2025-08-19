#!/usr/bin/env python3
"""
AppTypography Bulk Migration Script

This script performs bulk replacement of TextStyle and FontHelper patterns
across all Flutter Dart files to use the new AppTypography system.
"""

import os
import re
import glob

# Define the base directory
BASE_DIR = 'lib'

# Migration mappings
MIGRATION_PATTERNS = [
    # Basic TextStyle patterns
    (r'TextStyle\s*\(\s*fontSize:\s*12\s*,?\s*\)', 'AppTypography.bodySmall()'),
    (r'TextStyle\s*\(\s*fontSize:\s*14\s*,?\s*\)', 'AppTypography.bodyMedium()'),
    (r'TextStyle\s*\(\s*fontSize:\s*16\s*,?\s*\)', 'AppTypography.bodyLarge()'),
    (r'TextStyle\s*\(\s*fontSize:\s*18\s*,?\s*\)', 'AppTypography.heading5()'),
    (r'TextStyle\s*\(\s*fontSize:\s*20\s*,?\s*\)', 'AppTypography.heading4()'),
    (r'TextStyle\s*\(\s*fontSize:\s*24\s*,?\s*\)', 'AppTypography.heading3()'),
    (r'TextStyle\s*\(\s*fontSize:\s*11\s*,?\s*\)', 'AppTypography.caption()'),
    
    # TextStyle with color patterns
    (r'TextStyle\s*\(\s*fontSize:\s*12\s*,\s*color:\s*([^)]+)\s*\)', r'AppTypography.bodySmall(color: \1)'),
    (r'TextStyle\s*\(\s*fontSize:\s*14\s*,\s*color:\s*([^)]+)\s*\)', r'AppTypography.bodyMedium(color: \1)'),
    (r'TextStyle\s*\(\s*fontSize:\s*16\s*,\s*color:\s*([^)]+)\s*\)', r'AppTypography.bodyLarge(color: \1)'),
    (r'TextStyle\s*\(\s*fontSize:\s*18\s*,\s*color:\s*([^)]+)\s*\)', r'AppTypography.heading5(color: \1)'),
    (r'TextStyle\s*\(\s*fontSize:\s*20\s*,\s*color:\s*([^)]+)\s*\)', r'AppTypography.heading4(color: \1)'),
    (r'TextStyle\s*\(\s*fontSize:\s*24\s*,\s*color:\s*([^)]+)\s*\)', r'AppTypography.heading3(color: \1)'),
    
    # TextStyle with fontWeight patterns
    (r'TextStyle\s*\(\s*fontSize:\s*12\s*,\s*fontWeight:\s*FontWeight\.(?:w600|w500|bold)\s*\)', 'AppTypography.labelSmall()'),
    (r'TextStyle\s*\(\s*fontSize:\s*14\s*,\s*fontWeight:\s*FontWeight\.(?:w600|w500|bold)\s*\)', 'AppTypography.labelMedium()'),
    (r'TextStyle\s*\(\s*fontSize:\s*16\s*,\s*fontWeight:\s*FontWeight\.(?:w600|w500|bold)\s*\)', 'AppTypography.labelLarge()'),
    (r'TextStyle\s*\(\s*fontSize:\s*18\s*,\s*fontWeight:\s*FontWeight\.(?:w600|w500|bold)\s*\)', 'AppTypography.heading5()'),
    (r'TextStyle\s*\(\s*fontSize:\s*20\s*,\s*fontWeight:\s*FontWeight\.(?:w600|w500|bold)\s*\)', 'AppTypography.heading4()'),
    (r'TextStyle\s*\(\s*fontSize:\s*24\s*,\s*fontWeight:\s*FontWeight\.(?:w600|w500|bold)\s*\)', 'AppTypography.heading3()'),
    
    # FontHelper patterns
    (r'FontHelper\.ts12w400\(\)', 'AppTypography.bodySmall()'),
    (r'FontHelper\.ts14w400\(\)', 'AppTypography.bodyMedium()'),
    (r'FontHelper\.ts16w400\(\)', 'AppTypography.bodyLarge()'),
    (r'FontHelper\.ts18w400\(\)', 'AppTypography.heading5()'),
    (r'FontHelper\.ts20w400\(\)', 'AppTypography.heading4()'),
    (r'FontHelper\.ts12w600\(\)', 'AppTypography.labelSmall()'),
    (r'FontHelper\.ts14w600\(\)', 'AppTypography.labelMedium()'),
    (r'FontHelper\.ts16w600\(\)', 'AppTypography.labelLarge()'),
    (r'FontHelper\.ts18w600\(\)', 'AppTypography.heading5()'),
    (r'FontHelper\.ts20w600\(\)', 'AppTypography.heading4()'),
    
    # FontHelper with color patterns
    (r'FontHelper\.ts12w400\(color:\s*([^)]+)\)', r'AppTypography.bodySmall(color: \1)'),
    (r'FontHelper\.ts14w400\(color:\s*([^)]+)\)', r'AppTypography.bodyMedium(color: \1)'),
    (r'FontHelper\.ts16w400\(color:\s*([^)]+)\)', r'AppTypography.bodyLarge(color: \1)'),
    (r'FontHelper\.ts18w400\(color:\s*([^)]+)\)', r'AppTypography.heading5(color: \1)'),
    (r'FontHelper\.ts20w400\(color:\s*([^)]+)\)', r'AppTypography.heading4(color: \1)'),
]

# Files to migrate
TARGET_FILES = [
    'lib/features/**/*.dart',
    'lib/widgets/**/*.dart',
    'lib/shared/**/*.dart',
]

def migrate_file(file_path):
    """Migrate a single file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        changes_made = False
        
        # Apply migration patterns
        for pattern, replacement in MIGRATION_PATTERNS:
            new_content = re.sub(pattern, replacement, content, flags=re.MULTILINE | re.DOTALL)
            if new_content != content:
                content = new_content
                changes_made = True
        
        # Add AppTypography import if needed and changes were made
        if changes_made and 'AppTypography' in content and 'import \'package:sl/shared/typography.dart\';' not in content:
            # Find the import section and add the import
            import_pattern = r'(import \'package:flutter/material\.dart\';)'
            if re.search(import_pattern, content):
                content = re.sub(
                    import_pattern,
                    r'\1\nimport \'package:sl/shared/typography.dart\';',
                    content
                )
                
        # Remove FontHelper import if no longer needed
        if 'FontHelper' not in content and 'import \'../../shared/font_helper.dart\';' in content:
            content = re.sub(r'import \'[^\']*font_helper\.dart\';\n?', '', content)
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f'✓ Migrated: {file_path}')
            return True
        else:
            return False
            
    except Exception as e:
        print(f'✗ Error migrating {file_path}: {e}')
        return False

def main():
    """Main migration function."""
    print('Starting AppTypography Migration...')
    print('=' * 50)
    
    migrated_count = 0
    total_count = 0
    
    # Find all dart files
    for pattern in TARGET_FILES:
        for file_path in glob.glob(pattern, recursive=True):
            if file_path.endswith('.dart'):
                total_count += 1
                if migrate_file(file_path):
                    migrated_count += 1
    
    print('=' * 50)
    print(f'Migration complete!')
    print(f'Files processed: {total_count}')
    print(f'Files migrated: {migrated_count}')
    print('=' * 50)
    
    # Post-migration instructions
    print('Next steps:')
    print('1. Run: flutter analyze')
    print('2. Fix any remaining const issues')
    print('3. Test the app to ensure all styling works correctly')

if __name__ == '__main__':
    main()
