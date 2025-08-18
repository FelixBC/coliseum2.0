import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coliseum/services/auth_service.dart';
import 'package:coliseum/services/localization_service.dart';

class SessionInfoWidget extends StatelessWidget {
  final bool showExtendedInfo;
  final VoidCallback? onExtendSession;
  final VoidCallback? onRefreshSession;

  const SessionInfoWidget({
    super.key,
    this.showExtendedInfo = false,
    this.onExtendSession,
    this.onRefreshSession,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (!authService.isAuthenticated || !authService.isSessionValid) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: authService.isSessionExpiringSoon
                  ? Colors.orange.withOpacity(0.5)
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    authService.isSessionExpiringSoon
                        ? Icons.warning_amber_rounded
                        : Icons.security_rounded,
                    color: authService.isSessionExpiringSoon
                        ? Colors.orange
                        : Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Session Status',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  if (authService.isSessionExpiringSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Expiring Soon',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Session info
              _buildSessionInfoRow(
                context,
                'Provider',
                authService.currentUser?.authProvider?.toUpperCase() ?? 'Unknown',
                Icons.account_circle_outlined,
              ),
              
              if (showExtendedInfo) ...[
                const SizedBox(height: 8),
                _buildSessionInfoRow(
                  context,
                  'Last Activity',
                  _formatDateTime(authService.getSessionInfo()['lastActivity']),
                  Icons.access_time_outlined,
                ),
                
                const SizedBox(height: 8),
                _buildSessionInfoRow(
                  context,
                  'Session Expires',
                  _formatDateTime(authService.getSessionInfo()['sessionExpiry']),
                  Icons.timer_outlined,
                ),
                
                if (authService.remainingSessionTime != null) ...[
                  const SizedBox(height: 8),
                  _buildSessionInfoRow(
                    context,
                    'Time Remaining',
                    _formatDuration(authService.remainingSessionTime!),
                    Icons.schedule_outlined,
                  ),
                ],
              ],
              
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                children: [
                  if (onExtendSession != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          authService.extendSession();
                          onExtendSession?.call();
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Extend Session'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  
                  if (onExtendSession != null && onRefreshSession != null)
                    const SizedBox(width: 8),
                  
                  if (onRefreshSession != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          authService.refreshSession();
                          onRefreshSession?.call();
                        },
                        icon: const Icon(Icons.sync, size: 18),
                        label: const Text('Refresh'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSessionInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 'Unknown';
    
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}

// Compact version for app bars or small spaces
class CompactSessionInfoWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const CompactSessionInfoWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (!authService.isAuthenticated || !authService.isSessionValid) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: authService.isSessionExpiringSoon
                  ? Colors.orange.withOpacity(0.2)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: authService.isSessionExpiringSoon
                    ? Colors.orange.withOpacity(0.5)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  authService.isSessionExpiringSoon
                      ? Icons.warning_amber_rounded
                      : Icons.security_rounded,
                  color: authService.isSessionExpiringSoon
                      ? Colors.orange
                      : Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  authService.isSessionExpiringSoon ? 'Expiring' : 'Active',
                  style: TextStyle(
                    color: authService.isSessionExpiringSoon
                        ? Colors.orange.shade700
                        : Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
