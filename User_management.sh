# Author: Vijay Sankar C
# Description: This script is for managing user accounts on a Linux system.
            # The script allows administrators to add, modify, and delete user accounts,
            # set password policies, and manage user permissions.
# Script_Name: User_management.sh

#!/bin/bash
# Author: Vijay Sankar C
# Description: This script is for managing user accounts on a Linux system.
# The script allows administrators to add, modify, and delete user accounts,
# set password policies, and manage user permissions.
# Script_Name: User_management.sh

# Function to add a user
add_user() {
    read -p "Enter the username: " username
    if id "$username" &>/dev/null; then
        echo "The user $username already exists."
    else
        read -p "Enter the full name: " full_name
        read -sp "Enter the password: " password
        echo

        sudo useradd -m -c "$full_name" "$username" # Add the user with provided details
        echo "$username:$password" | sudo chpasswd # Set the user's password
        echo "User $username has been added successfully."
    fi
}

# Function to modify a user
mod_user() {
    read -p "Enter the username: " username
    if id "$username" &>/dev/null; then
        read -p "Enter the new full name for $username: " full_name
        if [ -n "$full_name" ]; then
            sudo usermod -c "$full_name" "$username" # Modify the user's full name
            echo "The full name of the user $username has been modified successfully."
        fi
        read -p "Do you want to change the password for the user $username (Yes/No): " change_password
        if [[ "$change_password" == "Yes" ]]; then
            read -sp "Enter the new password for $username: " password
            echo
            read -sp "Re-enter the new password: " password_re_entered
            echo

            if [[ "$password" == "$password_re_entered" ]]; then
                echo "$username:$password" | sudo chpasswd # Update the user's password
                echo "The password for user $username has been modified successfully."
            else
                echo "The entered passwords do not match."
            fi
        fi
    else
        echo "You have entered an invalid username: $username"
    fi
}

# Function to delete a user
del_user() {
    read -p "Enter the username you want to delete: " username
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username" # Delete the user
        echo "The user $username has been deleted successfully."
    else
        echo "You have entered an invalid username: $username"
    fi
}

# Function to set password policies
set_password_policies() {
    echo "Set the password policies:"
    read -p "Enter the minimum length of the password: " pass_min_len
    read -p "Enter the maximum age of the password: " pass_max_age
    read -p "Enter the minimum age of the password: " pass_min_age
    read -p "Enter the warning age of the password: " pass_warn_age

    # Set the password policies
    sudo sed -i "s/^PASS_MIN_LEN.*/PASS_MIN_LEN $pass_min_len/" /etc/login.defs
    sudo sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS $pass_max_age/" /etc/login.defs
    sudo sed -i "s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS $pass_min_age/" /etc/login.defs
    sudo sed -i "s/^PASS_WARN_AGE.*/PASS_WARN_AGE $pass_warn_age/" /etc/login.defs

    echo "Password policies have been set successfully."
}

# Function to manage user permissions
manage_user_permissions() {
    read -p "Enter the username to modify permissions: " username
    if id "$username" &>/dev/null; then
        echo "Current groups for $username:"
        groups "$username"

        read -p "Enter groups to add (comma-separated): " add_groups
        read -p "Enter groups to remove (comma-separated): " remove_groups

        # Add the user to new groups
        IFS=',' read -r -a add_array <<< "$add_groups"
        for group in "${add_array[@]}"; do
            sudo usermod -aG "$group" "$username"
        done

        # Remove the user from specified groups
        IFS=',' read -r -a remove_array <<< "$remove_groups"
        for group in "${remove_array[@]}"; do
            sudo gpasswd -d "$username" "$group"
        done

        echo "Updated groups for $username:"
        groups "$username"
    else
        echo "User $username does not exist."
    fi
}

# Main menu
while true; do
    echo "User Account Management Script"
    echo "1. Add User"
    echo "2. Modify User"
    echo "3. Delete User"
    echo "4. Set Password Policies"
    echo "5. Manage User Permissions"
    echo "6. Exit"
    read -p "Enter your choice: " choice

    case "$choice" in
        1)
            add_user
            ;;
        2)
            mod_user
            ;;
        3)
            del_user
            ;;
        4)
            set_password_policies
            ;;
        5)
            manage_user_permissions
            ;;
        6)
            echo "Exiting."
            exit
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done

