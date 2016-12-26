/*
 * a is a proper, existing user
 * b is a proper, existing admin
 * c needs to be added to users list
 * d needs to be added to admins list
 * e needs to be deleted from users list
 * f needs to be deleted from admins list
 * g needs to be promoted from user to admin
 * h needs to be demoted from admin to user
*/

var readmeUsers = ["a", "c", "h"],
	readmeAdmins = ["b", "d", "g"],
	computerUsers = ["a", "e", "g"],
	computerAdmins = ["b", "f", "h"],
	i;

// Contains -- Array Method
Array.prototype.contains = function (item) {
	return (this.indexOf(item) > -1);
};

// Full Algorithm
for (i = 0; i < computerUsers.length; i++) {
	if (!readmeUsers.contains(computerUsers[i])) {
		if (readmeAdmins.contains(computerUsers[i])) {
			// This user needs to be promoted from user to admin.
		} else {
			// This user needs to be deleted from the users list.
		}
	}
}

for (i = 0; i < computerAdmins.length; i++) {
	if (!readmeAdmins.contains(computerAdmins[i])) {
		if (readmeUsers.contains(computerAdmins[i])) {
			// This admin needs to be demoted from admin to user.
		} else {
			// This admin needs to be deleted from the admin list.
		}
	}
}

for (i = 0; i < readmeUsers.length; i++) {
	if (!computerUsers.contains(readmeUsers[i])) {
		// This user needs to be added to the users list.
	}
}

for (i = 0; i < readmeAdmins.length; i++) {
	if (!computerAdmins.contains(readmeAdmins[i])) {
		// This user needs to be added to the admins list.
	}
}

// Deletion Algorithm
for (i = 0; i < computerUsers.length; i++) {
	if (!readmeUsers.contains(computerUsers[i])) {
		// This user either needs to be deleted from users list, or promoted from user to admin.
		if (readmeAdmins.contains(computerUsers[i])) {
			// This user needs to be promoted from user to admin.
		} else {
			// This user needs to be deleted from the users list.
		}
	}
}
for (i = 0; i < computerAdmins.length; i++) {
	if (!readmeAdmins.contains(computerAdmins[i])) {
		// This admin either needs to be deleted from admins list, or demoted from admin to user.
		if (readmeUsers.contains(computerAdmins[i])) {
			// This admin needs to be demoted from admin to user.
		} else {
			// This admin needs to be deleted from the admin list.
		}
	}
}

// Addition Algorithm
for (i = 0; i < readmeUsers.length; i++) {
	if (!computerUsers.contains(readmeUsers[i])) {
		// This user either needs to be added to users list, or demoted from admin to user.
		if (computerAdmins.contains(readmeUsers[i])) {
			// This user exists as an admin, and needs to be demoted from admin to user.
		} else {
			// This user does not exist at all, and needs to be added to the users list.
		}
	}
}
for (i = 0; i < readmeAdmins.length; i++) {
	if (!computerAdmins.contains(readmeAdmins[i])) {
		// This admin either needs to be added to admins list, or promoted from user to admin.
		if (computerUsers.contains(readmeAdmins[i])) {
			// This admin exists as an user, and needs to be promoted from user to admin.
		} else {
			// This admin does not exist at all, and needs to be added to the admin list.
		}
	}
}